class Api::Teachers::TeachersController < Api::Teachers::BaseController
  before_action :admin_teacher, only: %i[create edit update]

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
    @user = User.find_by(id: params[:id], role: 1..3)
    if @user
      render :edit, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def update
    if @user ||= User.find_by(id: params[:id], role: 1..3)
      if @user.update(user_params)
        render :update, formats: :json, handlers: :jbuilder
      else
        record_invalid(@user)
      end
    else
      not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school, :role)
  end
end
