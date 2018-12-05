class Api::Teachers::QuestionsController < Api::Teachers::BaseController
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

  private

  def question_params
    params.require(:question).permit(:sentence, :type, :correct)
  end
end
