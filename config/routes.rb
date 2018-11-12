Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    get    '/auth', to: 'auth#show'
    post   '/auth', to: 'auth#create'
    delete '/auth', to: 'auth#destroy'

    # 講師用のpath
    namespace :teachers do
      resources :students, only: %i[create]
      resources :teachers, only: %i[create edit update]
    end
  end
end
