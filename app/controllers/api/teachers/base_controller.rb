class Api::Teachers::BaseController < ApplicationController
  before_action :require_login
end
