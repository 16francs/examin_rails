json.status :success

json.problem do
  json.extract! @problem, :id, :title, :content, :user_id, :created_at, :updated_at
  json.problems @problem.questions do |question|
    json.extract! question, :id, :sentence, :type, :correct
    json.answers question.answers do |answer|
      json.extract! answer, :choice
    end
  end
end
