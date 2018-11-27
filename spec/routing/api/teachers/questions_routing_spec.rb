require 'rails_helper'

RSpec.describe Api::Teachers::QuestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/teachers/problems/1/questions')
        .to route_to('api/teachers/questions#index', problem_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/teachers/problems/1/questions/1')
        .to route_to('api/teachers/questions#show', id: '1', problem_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/teachers/problems/1/questions')
        .to route_to('api/teachers/questions#create', problem_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/api/teachers/problems/1/questions/1/edit')
        .to route_to('api/teachers/questions#edit', id: '1', problem_id: '1')
    end

    it 'routes to #update' do
      expect(put: '/api/teachers/problems/1/questions/1/')
        .to route_to('api/teachers/questions#update', id: '1', problem_id: '1')
    end
  end
end
