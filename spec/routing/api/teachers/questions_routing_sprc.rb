# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::QuestionsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/problems/1/questions')
      .to route_to('api/teachers/problems#index', problem_id: '1')
  end
end
