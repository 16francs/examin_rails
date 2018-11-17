require 'rails_helper'

RSpec.describe Api::Teachers::QuestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/teachers/problems/1/questions')
        .to route_to('api/teachers/questions#index', problem_id: '1')
    end
  end
end
