# frozen_string_literal: true

class ApplicationOperation < Trailblazer::Operation
  protected

  def handle_validation_error!(*)
    raise ApiErrors::ValidationError
  end

  def handle_internal_error!(*)
    raise ApiErrors::OperationError
  end
end
