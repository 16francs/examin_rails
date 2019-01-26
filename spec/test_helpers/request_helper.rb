# frozen_string_literal: true

require 'rails_helper'

module RequestHelper
  # 引数で渡された user でログインする
  def login(user)
    params = {
      login_id: user[:login_id],
      password: '12345678'
    }.to_json

    headers = {
      ACCEPT: 'application/json',
      CONTENT_TYPE: 'application/json'
    }

    post '/api/auth', params: params, headers: headers
  end

  # 認証用情報の取得
  def get_auth_params(response)
    # json の body から認証用のトークンを取得
    json = JSON.parse(response.body)
    token = json['token']

    # トークンを認証に使用できる形に整形して返す
    authorization = 'Bearer ' + token
    { Authorization: authorization }
  end
end
