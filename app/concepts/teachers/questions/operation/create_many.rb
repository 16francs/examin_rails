# frozen_string_literal: true

class Teachers::Questions::Operation::CreateMany < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!, fail_fast: true

  private

  def validate!(options, params, **)
    # 存在する問題集かの検証
    return false unless Problem.pluck(:id).include?(params[:problem_id].to_i)

    # エクセルファイルの読み込み
    # 値の取得とバリデーションチェック -> nil が帰ってきたとき、エラーあり
    options[:contract] = validate_questions(params[:file])
    !options[:contract].nil?
  end

  def persist!(options, params, **)
    problem_id = params[:problem_id]
    questions = options[:contract]

    # 問題の一括登録
    questions.map! do |question|
      Question.new(
        problem_id: problem_id,
        sentence: question.sentence,
        correct: question.correct
      )
    end
    Question.import questions, validation: false

    # import では登録後の値が種ときできない
    # -> DB にアクセスし、questions の個数分後ろから値を取得
    options[:model] = Question.last(questions.count)
  end

  # -------- 以下、エクセルファイルの処理 ---------

  # エクセルから問題を取得・バリデーションチェックを行うメソッド
  def validate_questions(file)
    contracts = [] # 取得した問題を格納する配列

    # 正しいファイルが読み込めたかの検証
    spreadsheet = open_spreadsheet(file)
    return nil unless spreadsheet

    # ヘッダーを検証
    spreadsheet_head = spreadsheet.row(1) # 1行目のヘッダー情報を取得
    header = header_attributes
    return nil unless spreadsheet_head == header

    # 2行目から1行ずつ問題情報を取得し登録
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # バリデーションチェック
      contract = Teachers::Questions::Contract::CreateMany.new(Question.new)
      contract.sentence = row['問題']
      contract.correct = row['解答']
      # バリデーションチェック時、エラーがあれば処理の終了し、nil を返す
      return nil unless contract.valid?

      contracts << contract
    end

    # 全ての処理が正常に終了時、 contracts を返す
    contracts
  end

  # エクセルファイルの読み込み用メソッド
  def open_spreadsheet(file)
    Roo::Spreadsheet.open(file.path, extension: :xlsx) if file && File.extname(file.original_filename) == '.xlsx'
  end

  # ヘッダーの値の検証用メソッド
  def header_attributes
    %w[問題番号 問題 解答]
  end
end
