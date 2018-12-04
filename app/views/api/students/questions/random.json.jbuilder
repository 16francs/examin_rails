json.questions @tests.each do |test|
  json.extract! test, :question_id, :sentence, :type, :correct, :answers
end
