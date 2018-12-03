class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def check_unique
    render json: { check_unique: title_unique? }
  end

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

  def title_unique?
    if params[:id] # update or create
      return true if Problem.pluck(:title).exclude?(params[:title])

      problem = Problem.find(params[:id])
      problem[:title] == params[:title]
    else
      Problem.pluck(:title).exclude?(params[:title])
    end
  end

  def problem_params
    puts 'correct: ' + params[:problem][:questions_attributes][0][:correct]
    params.require(:problem).permit(
      :title, :content,
      questions_attributes: [
        :sentence,
        :type,
        :correct,
        answers_attributes: [
          :choice
        ]
      ]
    )
  end
end
