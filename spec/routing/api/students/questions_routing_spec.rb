require 'rails_helper'

RSpec.describe Api::Students::QuestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/students/problems/1/questions')
        .to route_to('api/students/questions#index', problem_id: '1')
    end
  end
end
