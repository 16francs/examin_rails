# frozen_string_literal: true

json.problem do
  json.extract! @response, :id, :title, :content, :teacher_name, :tags
  json.updated_at default_time(@response[:updated_at])
end
