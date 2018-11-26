require 'rails_helper'

RSpec.describe Api::Students::AchievementsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/students/problems/1/achievements')
        .to route_to('api/students/achievements#create', problem_id: '1')
    end
  end
end
