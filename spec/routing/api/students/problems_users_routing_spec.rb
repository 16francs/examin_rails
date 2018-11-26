require 'rails_helper'

RSpec.describe Api::Students::ProblemsUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/students/problems_users')
        .to route_to('api/students/problems_users#index')
    end

    it 'routes to #show' do
      expect(get: '/api/students/problems_users/1')
        .to route_to('api/students/problems_users#show', id: '1')
    end
  end
end
