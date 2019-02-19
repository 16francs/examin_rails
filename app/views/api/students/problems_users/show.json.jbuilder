# frozen_string_literal: true

json.problems_user @problems_user, :id, :problem_id, :created_at, :updated_at

json.achievements @problems_user.achievements do |achievement|
  json.extract! achievement, :id, :question_id, :result, :user_choice
  json.question do
    json.extract! achievement.question, :id, :sentence, :correct
  end
end