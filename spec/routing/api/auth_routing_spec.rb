require 'rails_helper'

RSpec.describe Api::AuthController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/auth').to route_to('api/auth#show')
    end

    it 'routes to #create' do
      expect(post: '/api/auth').to route_to('api/auth#create')
    end

    it 'routes to #update' do
      expect(put: '/api/auth').to route_to('api/auth#update')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/auth').to route_to('api/auth#destroy')
    end
  end
end
