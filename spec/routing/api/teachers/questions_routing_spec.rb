# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::QuestionsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/problems/1/questions')
      .to route_to('api/teachers/questions#index', problem_id: '1')
  end

  it 'routes to #create' do
    expect(post: '/api/teachers/problems/1/questions')
      .to route_to('api/teachers/questions#create', problem_id: '1')
  end

  it 'routes_ to #create_many' do
    expect(post: '/api/teachers/problems/1/questions/upload')
      .to route_to('api/teachers/questions#create_many', problem_id: '1')
  end
end
