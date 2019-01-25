# frozen_string_literal: true

require 'rails_helper'

describe Api::AuthController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/auth').to route_to('api/auth#index')
  end

  it 'routes to #create' do
    expect(post: '/api/auth').to route_to('api/auth#create')
  end
end
