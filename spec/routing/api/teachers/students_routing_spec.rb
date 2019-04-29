# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::StudentsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/students').to route_to('api/teachers/students#index')
  end

  it 'routes to #create' do
    expect(post: '/api/teachers/students').to route_to('api/teachers/students#create')
  end
end
