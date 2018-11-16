require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'エラー処理' do
    describe 'サーバー側のエラーの場合 500' do
      controller do
        def index
          raise StandardError
        end
      end

      it { should rescue_from(StandardError).with(:internal_server_error) }

      it 'method internal_server_error' do
        get :index
        expect(response.status).to eq(500)
      end
    end
  end
end
