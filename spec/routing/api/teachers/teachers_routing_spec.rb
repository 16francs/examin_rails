# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::TeachersController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/teachers').to route_to('api/teachers/teachers#index')
  end

  it 'routes to #create' do
    expect(post: '/api/teachers/teachers').to route_to('api/teachers/teachers#create')
  end
end
