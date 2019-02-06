# frozen_string_literal: true

json.teachers @response do |teacher|
  json.extract! teacher, :id, :name, :school, :role
end
