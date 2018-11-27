require 'rails_helper'

RSpec.describe Api::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #check_unique' do
      expect(post: '/api/users/check_unique').to route_to('api/users#check_unique')
    end

    it 'routes to #update' do
      expect(put: '/api/users').to route_to('api/users#update')
    end
  end
end
