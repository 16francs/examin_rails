# frozen_string_literal: true

json.questions @response do |question|
  json.extract! question, :id, :sentence, :correct
end
