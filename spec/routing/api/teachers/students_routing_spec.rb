require 'rails_helper'

RSpec.describe Api::Teachers::StudentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/teachers/students')
        .to route_to('api/teachers/students#create')
    end
  end
end
