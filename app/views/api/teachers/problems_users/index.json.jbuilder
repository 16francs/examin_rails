json.problems_users @problems_users do |problems_user|
  json.extract! problems_user, :id, :problem_id, :user_id, :created_at, :updated_at
  json.user problems_user.user, :id, :name
end
