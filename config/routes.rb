Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    resources :auth, only: [:create]

    # 講師用のpath
    namespace :teachers do
      resources :teachers, only: [:create]
    end
  end
end
