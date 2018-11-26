class Api::Teachers::TeachersController < Api::Teachers::BaseController
  before_action :correct_teacher, only: %i[edit update]

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

  def login_id_unique? # rubocop:disable AbcSize
    if params[:id] # update or create
      return true if User.pluck(:login_id).exclude?(params[:login_id])

      if current_user[:id] == params[:id].to_i # current user or not
        current_user[:login_id] == params[:login_id]
      else
        user = User.find(params[:id])
        user[:login_id] == params[:login_id]
      end
    else
      User.pluck(:login_id).exclude?(params[:login_id])
    end
  end

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
