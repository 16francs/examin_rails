# frozen_string_literal: true

class Api::Students::ProblemsUsersController < Api::Students::BaseController
  def index
    @problems_users = ProblemsUser.where(User_id: @current_user)
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problems_user = ProblemsUser.find_by(id: params[:id])
    render :show, formats: :json, handler: :jbuilder
  end

  private

  def correct_student
    problems_user = ProblemsUser.find_by(params[:id])
    forbidden unless correct_student?(problems_user.user)
  end
end
