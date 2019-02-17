# frozen_string_literal: true

json.problem @problem, :id, :title, :user_id, :created_at, :updated_at

json.questions @problem.questions.each do |question|
  json.extract! question, :id, :sentence, :correct
end