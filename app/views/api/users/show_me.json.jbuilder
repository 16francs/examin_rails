# frozen_string_literal: true

json.extract! @response, :id, :login_id, :name, :school, :role
json.created_at default_time(@response[:created_at])
json.updated_at default_time(@response[:updated_at])
