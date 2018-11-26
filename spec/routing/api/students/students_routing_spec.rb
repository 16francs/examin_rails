require 'rails_helper'

RSpec.describe Api::Students::StudentsController, type: :routing do
  describe 'routing' do
    it 'routes to #check_unique' do
      expect(post: '/api/students/students/check_unique')
        .to route_to('api/students/students#check_unique')
    end

    it 'routes to #show' do
      expect(get: '/api/students/students/1')
        .to route_to('api/students/students#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/api/students/students/1/edit')
        .to route_to('api/students/students#edit', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/api/students/students/1')
        .to route_to('api/students/students#update', id: '1')
    end
  end
end
