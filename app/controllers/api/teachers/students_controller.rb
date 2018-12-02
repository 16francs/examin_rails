class Api::Teachers::StudentsController < Api::Teachers::BaseController
  before_action :admin_teacher, only: %i[check_unique create edit update]

  def index
    @users = User.where(role: 0)
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @user = User.find_by(id: params[:id], role: 0)
    if @user
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def create
    @user = User.new(user_params)
    @user[:role] = 0
    if @user.save
      render :create, formats: :json, handlers: :jbuilder
    else
      record_invalid(@user)
    end
  end

  def edit
    @user = User.find_by(id: params[:id], role: 0)
    if @user
      render :edit, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end

  def update
    if @user ||= User.find_by(params[:id], role: 0)
      if @user.update(user_params)
        render :update, formats: :json, handelrs: :jbuilder
      else
        record_invalid(@user)
      end
    else
      not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
