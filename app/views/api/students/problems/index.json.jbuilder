json.problems @problems.each do |problem|
  json.extract! problem, :id, :title, :content, :user_id, :created_at, :updated_at
end
