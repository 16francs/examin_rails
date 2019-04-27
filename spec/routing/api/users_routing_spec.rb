# frozen_string_literal: true

require 'rails_helper'

describe Api::UsersController, type: :routing do
  it 'routes to #show_me' do
    expect(get: '/api/users/me').to route_to('api/users#show_me')
  end

  it 'routes to #update_me' do
    expect(patch: '/api/users/me').to route_to('api/users#update_me')
  end

  it 'routes to #check_unique' do
    expect(post: '/api/users/check_unique').to route_to('api/users#check_unique')
  end
end
