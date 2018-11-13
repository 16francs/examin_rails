class Api::Teachers::StudentsController < Api::Teachers::BaseController
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
