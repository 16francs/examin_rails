module ProblemsService
  # エクセルから問題を登録するメソッド
  def create_questions(file, problem)
    # 正しいファイルが読み込めた場合のみ問題登録処理を行う
    if spreadsheet ||= open_spreadsheet(file)
      spreadsheet_head = spreadsheet.row(1) # 1行目のヘッダー情報を取得
      header = header_attributes
      # ヘッダーを検証
      if spreadsheet_head == header
        # 2行目から1行ずつ問題情報を取得し登録
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          Question.create(problem_id: problem[:id], sentence: row['問題'], correct: row['解答'])
        end
      else
        @error = '正しいファイルをアップロードしてください'
      end
    else
      @error = '正しいファイルをアップロードしてください'
    end
  end

  private

  # エクセルファイルの読み込み用メソッド
  def open_spreadsheet(file)
    Roo::Spreadsheet.open(file.path, extension: :xlsx) if file && File.extname(file.original_filename) == '.xlsx'
  end

  # ヘッダーの値の検証用メソッド
  def header_attributes
    %w[問題番号 問題 解答]
  end
end
