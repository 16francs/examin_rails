require 'rails_helper'

RSpec.describe Api::Teachers::ProblemsUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/teachers/problems_users')
        .to route_to('api/teachers/problems_users#index')
    end

    it 'routes to #show' do
      expect(get: '/api/teachers/problems_users/1')
        .to route_to('api/teachers/problems_users#show', id: '1')
    end
  end
end
