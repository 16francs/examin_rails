class Api::Teachers::TeachersController < Api::Teachers::BaseController
  before_action :correct_teacher, only: %i[edit update]

  def index
    @users = User.where(role: 1..3)
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @user = User.find_by(id: params[:id], role: 1..3)
    if @user
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def create
    @user = User.new(user_params)
    @user[:role] = 1
    if @user.save
      render :create, formats: :json, handlers: :jbuilder
    else
      record_invalid(@user)
    end
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

  def correct_teacher
    user = User.find(params[:id])
    forbidden unless correct_teacher?(user)
  end

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
