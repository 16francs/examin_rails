# frozen_string_literal: true

class Teachers::TeachersService
  attr_reader :response

  def initialize
    @response = nil
  end

  def index
    @response = []

    keys = %i[id name school role]
    teachers = User.where(activated: true, role: 1..2).pluck(:id, :name, :school, :role)
    teachers.map! { |teacher| Hash[*[keys, teacher].transpose.flatten] }

    @response = teachers
  end
end
