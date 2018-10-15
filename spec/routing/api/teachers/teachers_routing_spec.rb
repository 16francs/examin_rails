require 'rails_helper'

RSpec.describe Api::Teachers::TeachersController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/teachers/teachers')
        .to route_to('api/teachers/teachers#create')
    end
  end
end
