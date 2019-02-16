# frozen_string_literal: true

class Api::Students::QuestionsController < Api::Students::BaseController
  def index # 問題を全件取得
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end
end