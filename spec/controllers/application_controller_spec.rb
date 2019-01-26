# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  describe 'エラー処理' do
    context 'サーバーエラーの場合' do
      controller do
        def index
          raise StandardError
        end
      end

      before do
        get :index
      end

      it 'internal_server_error action' do
        should rescue_from(StandardError).with(:internal_server_error)
      end

      it 'status: 500' do
        expect(response.status).to eq(500)
      end
    end
  end
end
