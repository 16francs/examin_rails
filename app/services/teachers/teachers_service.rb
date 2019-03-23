# frozen_string_literal: true

class Teachers::TeachersService < ApplicationService
  def index
    keys = %i[id name school role]
    teachers = User.where(activated: true, role: 1..2).pluck(:id, :name, :school, :role)
    teachers.map! { |teacher| Hash[*[keys, teacher].transpose.flatten] }

    @response[:teachers] = teachers
  end

  def create(model)
    teacher = model.slice(:id, :name, :school, :role)
    teacher[:created_at] = default_time(model[:created_at])
    teacher[:updated_at] = default_time(model[:updated_at])

    @response = teacher
  end
end
