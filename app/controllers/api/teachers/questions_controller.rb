class Api::Teachers::QuestionsController < Api::Teachers::BaseController
  include QuestionsService
  before_action :admin_teacher, only: %i[destroy]

  def index
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @question = Question.find_by(id: params[:id])
    if @question
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def create
    @question = Question.new(question_params)
    @question[:problem_id] = params[:problem_id]
    if @question.save
      render :create, formats: :json, handlers: :jbuilder
    else
      record_invalid(@question)
    end
  end

  def edit
    @question = Question.find_by(id: params[:id])
    if @question
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def update
    if @question ||= Question.find_by(id: params[:id])
      if @question.update(question_params)
        render :update, formats: :json, handlers: :jbuilder
      else
        record_invalid(@question)
      end
    else
      not_found
    end
  end

  def destroy
    if question ||= Question.find_by(id: params[:id])
      question.destroy
      render json: { status: :success }, status: :ok
    else
      not_found
    end
  end

  def download_index
  end

  def download_test
    if @problem ||= Problem.find_by(id: params[:problem_id])
      @count = params[:count].to_i
      if @count == 20 || @count == 30 || @count == 50
        download_test_data
        send_data(excel_render(@file_path).stream.string, type: @file_type, filename: @file_name)
      else
        bad_request
      end
    else
      not_found
    end
  end

  private

  def question_params
    params.require(:question).permit(:sentence, :correct)
  end

  def question_ids(random)
    ids = Question.where(problem_id: params[:problem_id]).pluck(:id)
    random ? ids.sample(@count) : ids
  end

  def download_test_data
    @questions = Question.where(id: question_ids(true))
    @file_name = "テスト_#{@count}.xlsx"
    @file_path = Rails.root.join('lib', "new_tests_#{@count}.xlsx")
    @file_type = 'application/vnd.ms-excel'
  end
end
