json.problems_user do
  json.extract! @problems_user, :id, :created_at, :updated_at
  json.problem @problems_user.problem, :id, :title, :content
  json.user @problems_user.user, :id, :name
end

json.achievements @problems_user.achievements do |achievement|
  json.extract! achievement, :id, :result, :user_choice
  json.question do
    json.extract! achievement.question, :id, :sentence, :correct
  end
end
