json.problem do
  json.extract! @problem, :id, :title, :content, :created_at, :updated_at
  json.user @problem.user, :id, :name, :school
end
