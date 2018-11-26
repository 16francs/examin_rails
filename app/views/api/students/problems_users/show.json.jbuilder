json.problems_user @problems_user, :id, :problem_id, :created_at, :updated_at

json.achievements @problems_user.achievements do |achievement|
  json.extract! achievement, :id, :question_id, :result, :user_choice
  json.question do
    json.extract! achievement.question, :sentence, :correct
    json.answers achievement.question.answers, :id, :choice
  end
end
