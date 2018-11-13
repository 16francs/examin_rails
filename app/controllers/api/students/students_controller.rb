class Api::Students::StudentsController < Api::Students::BaseController
  before_action :correct_student

  def show
    @user = User.find(params[:id])
    render :show, formats: :json, handers: :jbuilder
  end

  private

  def correct_student
    user = User.find(params[:id])
    forbidden unless correct_student?(user)
  end
end
