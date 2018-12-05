class Api::Students::QuestionsController < Api::Students::BaseController
  def index
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end

  def random
    @count = params[:count] || 10 # デフォルトで10問取得
    @count = @count.to_i
    @test_type = params[:test_type] || 1
    @test_type = @test_type.to_i
    if @test_type == 1 || @test_type == 2
      @questions = Question.where(id: random_question_ids)
      @tests = create_tests(@questions)
      render :random, formats: :json, handlers: :jbuilder
    else
      render json: { status: :error, message: 'invalid_parameter' }, status: :bad_request
    end
  end

  private

  def random_question_ids
    Question.where(problem_id: params[:problem_id]).pluck(:id).sample(@count)
  end

  # json 用にデータを整形
  def create_tests(questions, tests = [])
    case @test_type
    when 1 then # 択一選択
      all_choice = Question.where(problem_id: questions[0][:problem_id]).pluck(:correct)
      tests = single_select_test(questions, all_choice)
    when 2 then # 文字入力
      tests = description_test(questions)
    end
    tests
  end

  # 択一選択型の問題を作成
  def single_select_test(questions, all_choice, tests = []) # rubocop:disable Metrics/MethodLength
    questions.each do |question|
      choice = all_choice.shuffle
      choice.delete(question[:correct])
      # 正解も含めて，選択肢が4になるように追加
      answers = [question[:correct]]
      correct = 0
      3.times do |index|
        if Random.rand(0..1) == 1
          answers.push(choice[index]) # 最後に追加
        else
          answers.unshift(choice[index]) # 先頭に追加
          correct += 1
        end
      end
      # 作成した問題を追加
      tests << {
        question_id: question[:id],
        sentence: question[:sentence],
        correct: correct,
        answers: answers
      }
    end
    tests
  end

  def description_test(questions, tests = [])
    questions.each do |question|
      tests << {
        question_id: question[:id],
        sentence: question[:sentence],
        correct: question[:correct],
        answers: []
      }
    end
    tests
  end
end
