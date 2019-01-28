# frozen_string_literal: true

class Api::Teachers::BaseController < ApplicationController
  before_action :require_login
  before_action :logged_in_teacher

  private

  def logged_in_teacher
    unauthorized unless @current_user[:role] == 1 || @current_user[:role] == 2
  end
end
