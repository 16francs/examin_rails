class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def index
    @problems = Problem.all
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problem = Problem.find_by(id: params[:id])
    if @problem
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def create
    @problem = Problem.new(problem_params)
    @problem[:user_id] = current_user[:id]
    if @problem.save
      render :create, formats: :json, handlers: :jbuilder
    else
      record_invalid(@problem)
    end
  end

  def edit
    @problem = Problem.find_by(id: params[:id])
    if @problem
      render :edit, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def update
    if @problem ||= Problem.find_by(id: params[:id])
      if @problem.update(problem_params)
        @problem.user = current_user
        @problem.save
        render :update, formats: :json, handlers: :jbuilder
      else
        record_invalid(@problem)
      end
    else
      not_found
    end
  end

  private

  def problem_params
    params.require(:problem).permit(:title, :content, questions_attributes: %i[sentence type correct])
  end
end
