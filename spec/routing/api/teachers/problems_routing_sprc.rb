# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::ProblemsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/problems').to route_to('api/teachers/problems#index')
  end
end