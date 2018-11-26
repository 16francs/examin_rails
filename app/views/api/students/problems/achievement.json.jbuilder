json.status :success

json.problems_user do
  json.extract! @problems_user, :id, :problem_id, :user_id, :created_at, :updated_at
  json.achievements @problems_user.achievements do |achievement|
    json.extract! achievement, :id, :question_id, :result, :user_choice
  end
end
