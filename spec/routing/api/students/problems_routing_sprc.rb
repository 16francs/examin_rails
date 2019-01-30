# frozen_string_literal: true

require 'rails_helper'

describe Api::Students::ProblemsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/students/problems').to route_to('api/students/problems#index')
  end
end
