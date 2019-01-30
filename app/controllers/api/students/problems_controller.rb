# frozen_string_literal: true

class Api::Students::ProblemsController < Api::Students::BaseController
  def index
    render json: {}, status: :ok
  end
end
