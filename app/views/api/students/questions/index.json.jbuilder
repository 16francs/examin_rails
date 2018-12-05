json.questions @questions.each do |question|
  json.extract! question, :id, :sentence, :correct, :created_at, :updated_at
end
