class Api::Students::QuestionsController < Api::Students::BaseController
  def index
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end

  def random
    @questions = Question.where(id: random_question_ids)
    @tests = create_tests(@questions)
    render :random, formats: :json, handlers: :jbuilder
  end

  private

  def random_question_ids
    count = params[:count] || 10 # デフォルトで10問取得
    Question.where(problem_id: params[:problem_id]).pluck(:id).sample(count.to_i)
  end

  def create_tests(questions)
    test = []
    all_choice = Question.where(problem_id: questions[0][:problem_id]).pluck(:correct)
    questions.each do |question|
      case question[:type]
      when 1 then # 択一選択
        test << single_select_test(question, all_choice)
      when 2 then # 文字入力
        test << description_test(question)
      else
        logger.error('テスト作成機能でエラー')
      end
    end
    test
  end

  def single_select_test(question, all_choice)
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
    # 作成した問題をテストに追加
    {
      question_id: question[:id],
      sentence: question[:sentence],
      type: question[:type],
      correct: correct,
      answers: answers
    }
  end

  def description_test(question)
    {
      question_id: question[:id],
      sentence: question[:sentence],
      type: question[:type],
      correct: question[:correct],
      answers: []
    }
  end
end
