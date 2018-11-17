json.questions @questions.each do |question|
  json.extract! question, :id, :sentence, :type, :correct, :created_at, :updated_at
  json.answers question.answers, :id, :choice
end
