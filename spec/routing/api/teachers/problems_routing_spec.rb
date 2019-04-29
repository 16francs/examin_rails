# frozen_string_literal: true

require 'rails_helper'

describe Api::Teachers::ProblemsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/api/teachers/problems').to route_to('api/teachers/problems#index')
  end

  it 'routes to #create' do
    expect(post: '/api/teachers/problems').to route_to('api/teachers/problems#create')
  end

  it 'routes to #download_template' do
    expect(get: '/api/teachers/problems/download')
      .to route_to('api/teachers/problems#download_template')
  end
end
