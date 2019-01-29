# frozen_string_literal: true

json.array! @response do |problem|
  json.extract! problem, :id, :title, :content, :teacher_name
  json.created_at default_time(problem[:created_at])
  json.updated_at default_time(problem[:updated_at])
end
