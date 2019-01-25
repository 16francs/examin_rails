# frozen_string_literal: true

json.extract! @response, :token, :expired_at
json.user do
  json.extract! @response[:user], :id, :role
end
