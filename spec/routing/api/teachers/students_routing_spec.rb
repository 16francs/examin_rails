require 'rails_helper'

RSpec.describe Api::Teachers::StudentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/teachers/students')
        .to route_to('api/teachers/students#index')
    end

    it 'routes to #show' do
      expect(get: '/api/teachers/students/1')
        .to route_to('api/teachers/students#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/teachers/students')
        .to route_to('api/teachers/students#create')
    end
  end
end
