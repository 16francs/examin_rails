# frozen_string_literal: true

json.problems @response do |problem|
  json.extract! problem, :id, :title, :content, :teacher_name
  json.updated_at default_time(problem[:updated_at])
end
