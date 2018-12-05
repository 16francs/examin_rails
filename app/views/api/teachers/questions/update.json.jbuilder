json.question do
  json.extract! @question, :id, :problem_id, :sentence, :correct, :created_at, :updated_at
end
