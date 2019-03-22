# frozen_string_literal: true

class Teachers::StudentsService < ApplicationService
  def create(model)
    student = model.slice(:id, :name, :school, :role)
    student[:created_at] = default_time(model[:created_at])
    student[:updated_at] = default_time(model[:updated_at])

    @response[:student] = student
  end
end
