Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    post '/auth', to: 'auth#create'

    # 講師用のpath
    namespace :teachers do
      resources :students, only: [:create]
      resources :teachers, only: [:create]
    end
  end
end
