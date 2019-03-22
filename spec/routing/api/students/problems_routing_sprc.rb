# frozen_string_literal: true

require 'rails_helper'

describe Api::Students::ProblemsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/students/problems').to route_to('api/students/problems#index')
  end

  it 'routes to #show' do
    expect(get: '/api/students/problems/1').to route_to('api/students/problems#show', id: '1')
  end

  it 'routes to #achievement' do
    expect(post: '/api/students/problems/1/achievement').to
      route_to('api/students/problems#achievement', problem_id: '1')
  end
end
