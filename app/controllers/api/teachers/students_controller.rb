class Api::Teachers::StudentsController < Api::Teachers::BaseController
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

  private

  def user_params
    params.require(:user)
          .permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
