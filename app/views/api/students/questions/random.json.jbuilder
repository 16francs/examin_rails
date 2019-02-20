# frozen_string_literal: true

json.count @count
json.test_type @test_type
json.questions @tests.each do |test|
  json.extract! test, :question_id, :sentence, :correct, :answers
end