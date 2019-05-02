# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Teachers::ProblemsService < ApplicationService
  def index
    keys = %i[id title content user_id updated_at]
    problems = Problem.order(updated_at: :desc).pluck(:id, :title, :content, :user_id, :updated_at)
    problems.map! { |problem| Hash[*[keys, problem].transpose.flatten] }

    problems.each do |problem|
      user = User.find_by(id: problem[:user_id]) # user_id が nil OK なため
      problem[:teacher_name] = user ? user[:name] : nil

      tag_ids = ProblemsTag.where(problem_id: problem[:id]).pluck(:tag_id)
      problem[:tags] = Tag.where(id: tag_ids).pluck(:content)

      problem[:updated_at] = default_time(problem[:updated_at])

      problem.delete(:user_id)
    end

    @response[:problems] = problems
  end

  def create(model)
    problem = model.slice(:id, :title, :content)
    problem[:created_at] = default_time(model[:created_at])
    problem[:updated_at] = default_time(model[:updated_at])

    user = User.find_by(id: model[:user_id])
    problem[:teacher_name] = user ? user[:name] : nil

    problem[:tags] = model.tags.pluck(:content)

    @response = problem
  end

  def download_template
    file = {}
    file[:path] = Rails.root.join('lib', 'new_questions.xlsx')
    file[:type] = 'application/vnd.ms-excel'

    file
  end

  def download_index(problem_id)
    file = {}
    problem = Problem.find(problem_id)
    questions = problem.questions

    file[:content] = index_render(problem, questions).stream.string
    file[:type] = 'application/vnd.ms-excel'
    file[:name] = "#{problem[:title]}.xlsx"

    file
  end

  def download_test(problem_id, test)
    # 入力値の検証
    # count -> 20, 30, 50 のみ, それ以外 -> error
    count = test[:count].to_i
    raise ApiErrors::BadRequest unless [20, 30, 50].include?(count)

    file = {}
    problem = Problem.find(problem_id)
    # 問題のランダム取得
    question_ids = problem.questions.pluck(:id).sample(count)
    questions = Question.where(id: question_ids).shuffle

    file[:content] = test_render(count.to_s, problem, questions).stream.string
    file[:type] = 'application/vnd.ms-excel'
    file[:name] = "test_#{count}.xlsx"

    file
  end

  private

  ## ------- 以下、問題集作成 -------
  # 問題集一覧出力
  def index_render(problem, questions)
    file = Rails.root.join('lib', 'questions.xlsx')
    excel = RubyXL::Parser.parse(file)
    # エクセルファイルの読み込み
    excel.tap do |workbook|
      worksheet = workbook.first
      # タイトル
      input_title_cell(worksheet, problem)
      # 問題一覧
      questions.each_with_index do |question, index|
        input_content_cell(worksheet, question, index)
      end
    end
  end

  # タイトルを代入
  def input_title_cell(worksheet, problem)
    title = worksheet.add_cell(0, 1, problem[:title])
    title.change_horizontal_alignment('center')
    title.change_font_size(18)
  end

  # 問題を代入
  def input_content_cell(worksheet, question, index)
    worksheet.add_cell(index + 3, 0, index + 1)
    worksheet.add_cell(index + 3, 1, question[:sentence])
    worksheet.add_cell(index + 3, 2, question[:correct])
  end

  ## ------- 以下、テスト作成 -------
  # テスト出力
  def test_render(count, problem, questions)
    file = Rails.root.join('lib', "tests_#{count}.xlsx")
    excel = RubyXL::Parser.parse(file)
    @problem = problem
    @questions = questions
    # エクセルファイルの読み込み
    excel.tap do |workbook|
      workbook.worksheets.each do |worksheet|
        worksheet.each_with_index do |row, row_num|
          # 1行ずつセルをみていく
          row&.cells&.each do |cell|
            next unless cell&.value # セルが空欄なら次へ

            cell_render(cell) # セルに値があればcell_renderへ
          end
          row_height_auto(worksheet, row_num)
        end
      end
    end
  end

  # セルへ値を代入するメソッド
  def cell_render(cell)
    cell.change_contents(content_eval(cell.value))
    cell.change_text_wrap(true) if (cell&.value&.lines("\n")&.count) > 1
  rescue StandardError
    # 値がnilの場合エラーメッセージを表示する
    cell.change_contents('error!')
    cell.change_font_color('FF0000')
    cell.change_fill('FFFF00')
  end

  # セルの値を取得
  # 変数が書かれているときは、変数の値を取得
  def content_eval(content)
    # rubocop:disable Security/Eval
    eval(content).gsub(/\R/, '\n')
    # rubocop:enable Security/Eval
  rescue StandardError
    content.inspect.include?('@') ? nil : content.to_s.gsub(/\R/, '\n')
  end

  def row_height_auto(worksheet, row_num)
    max_lines = worksheet[row_num]&.cells&.map { |cell| cell&.value&.lines("\n")&.count || 0 }&.max
    # 最小値が RubyXL::Row::DEFAULT_HEIGHT (= 13) では合わなかったので手動調整
    origin_height = [worksheet.get_row_height(row_num), 20].max
    worksheet.change_row_height(row_num, origin_height * max_lines) if max_lines&.positive?
  end
end
# rubocop:enable all
