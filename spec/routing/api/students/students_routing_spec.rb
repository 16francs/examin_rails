require 'rails_helper'

RSpec.describe Api::Students::StudentsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/students/students/1')
        .to route_to('api/students/students#show', id: '1')
    end
  end
end
