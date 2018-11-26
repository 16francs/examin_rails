class Api::Students::StudentsController < Api::Students::BaseController
  before_action :correct_student, only: %i[show edit update]

  def check_unique
    render json: { check_unique: login_id_unique? }
  end

  def show
    @user = User.find(params[:id])
    render :show, formats: :json, handers: :jbuilder
  end

  def edit
    @user = User.find(params[:id])
    render :edit, formats: :json, handlers: :jbuilder
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render :update, formats: :json, handlers: :jbuilder
    else
      record_invalid(@user)
    end
  end

  private

  def correct_student
    user = User.find(params[:id])
    forbidden unless correct_student?(user)
  end

  def login_id_unique?
    return true if User.pluck(:login_id).exclude?(params[:login_id])

    current_user[:login_id] == params[:login_id]
  end

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
