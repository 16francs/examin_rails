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

    it 'routes to #destroy' do
      expect(delete: '/api/teachers/problems/1/questions/1')
        .to route_to('api/teachers/questions#destroy', id: '1', problem_id: '1')
    end

    it 'routes to #download_index' do
      expect(post: '/api/teachers/problems/1/questions/download_index')
        .to route_to('api/teachers/questions#download_index', problem_id: '1')
    end

    it 'routes to #download_test' do
      expect(post: '/api/teachers/problems/1/questions/download_test')
          .to route_to('api/teachers/questions#download_test', problem_id: '1')
    end
  end
end
