require 'rails_helper'

RSpec.describe Api::Students::ProblemsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/students/problems')
        .to route_to('api/students/problems#index')
    end

    it 'routes to #show' do
      expect(get: '/api/students/problems/1')
        .to route_to('api/students/problems#show', id: '1')
    end
  end
end
