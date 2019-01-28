# frozen_string_literal: true

class Api::Students::BaseController < ApplicationController
  before_action :require_login
  before_action :logged_in_student

  private

  def logged_in_student
    unauthorized unless @current_user[:role] == 0
  end
end
