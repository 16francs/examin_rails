class Api::Teachers::TeachersController < Api::Teachers::BaseController
  before_action :admin_teacher, only: %i[create edit update]

  def check_unique
    render json: { check_unique: login_id_unique? }
  end

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
    @user = User.find_by(params[:id], role: 1..3)
    if @user.update(user_params)
      render :update, formats: :json, handlers: :jbuilder
    else
      record_invalid(@user)
    end
  end

  private

  def login_id_unique?
    if params[:id] # update or create
      return true if User.pluck(:login_id).exclude?(params[:login_id])

      user = User.find(params[:id])
      user[:login_id] == params[:login_id]
    else
      User.pluck(:login_id).exclude?(params[:login_id])
    end
  end

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
