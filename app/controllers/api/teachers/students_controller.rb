class Api::Teachers::StudentsController < Api::Teachers::BaseController
  before_action :admin_teacher, only: %i[edit update]

  def check_unique
    render json: { check_unique: login_id_unique? }
  end

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
    @user = User.find_by(params[:id], role: 0)
    render :edit, formats: :json, handlers: :jbuilder
  end

  def update
    @user = User.find_by(params[:id], role: 0)
    if @user.update(user_params)
      render :update, formats: :json, handelrs: :jbuilder
    else
      record_invalid(@user)
    end
  end

  private

  def login_id_unique?
    User.pluck(:login_id).exclude?(params[:login_id])
  end

  def user_params
    params.require(:user)
          .permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
