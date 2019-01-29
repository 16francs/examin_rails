# frozen_string_literal: true

require 'rails_helper'

describe Api::UsersController, type: :routing do
  it 'routes to #check_unique' do
    expect(post: '/api/users/check_unique').to route_to('api/users#check_unique')
  end
end
