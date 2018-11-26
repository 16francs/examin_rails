require 'rails_helper'

RSpec.describe Api::Teachers::TeachersController, type: :routing do
  describe 'routing' do
    it 'routes to #check_unique' do
      expect(post: '/api/teachers/teachers/check_unique')
        .to route_to('api/teachers/teachers#check_unique')

      expect(post: '/api/teachers/teachers/1/check_unique')
        .to route_to('api/teachers/teachers#check_unique', id: '1')
    end

    it 'routes to #index' do
      expect(get: '/api/teachers/teachers')
        .to route_to('api/teachers/teachers#index')
    end

    it 'routes to #show' do
      expect(get: '/api/teachers/teachers/1')
        .to route_to('api/teachers/teachers#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/teachers/teachers')
        .to route_to('api/teachers/teachers#create')
    end

    it 'routes to #edit' do
      expect(get: '/api/teachers/teachers/1/edit')
        .to route_to('api/teachers/teachers#edit', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/api/teachers/teachers/1')
        .to route_to('api/teachers/teachers#update', id: '1')
    end

    it 'routes to #edit_admin' do
      expect(get: '/api/teachers/teachers/1/edit_admin')
        .to route_to('api/teachers/teachers#edit_admin', id: '1')
    end

    it 'routes to #update_admin' do
      expect(put: '/api/teachers/teachers/1/update_admin')
        .to route_to('api/teachers/teachers#update_admin', id: '1')
    end
  end
end
