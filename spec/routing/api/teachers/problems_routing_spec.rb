require 'rails_helper'

RSpec.describe Api::Teachers::ProblemsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/teachers/problems')
        .to route_to('api/teachers/problems#index')
    end

    it 'routes to #show' do
      expect(get: '/api/teachers/problems/1')
        .to route_to('api/teachers/problems#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/teachers/problems')
        .to route_to('api/teachers/problems#create')
    end

    it 'routes to #edit' do
      expect(get: '/api/teachers/problems/1/edit')
        .to route_to('api/teachers/problems#edit', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/api/teachers/problems/1')
        .to route_to('api/teachers/problems#update', id: '1')
    end
  end
end
