# frozen_string_literal: true

class Teachers::StudentsService < ApplicationService
  def index
    keys = %i[id name school login_id role]
    students = User.where(activated: true, role: 0).pluck(:id, :name, :school, :login_id, :role)
    students.map! { |student| Hash[*[keys, student].transpose.flatten] }

    @response[:students] = students
  end

  def create(model)
    student = model.slice(:id, :name, :school, :login_id, :role)
    student[:created_at] = default_time(model[:created_at])
    student[:updated_at] = default_time(model[:updated_at])

    @response = student
  end
end
