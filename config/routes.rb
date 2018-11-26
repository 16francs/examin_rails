Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    get    '/auth', to: 'auth#show'
    post   '/auth', to: 'auth#create'
    delete '/auth', to: 'auth#destroy'

    # 講師用のpath
    namespace :teachers do
      resources :problems, only: %i[index show create edit update] do
        resources :questions, only: %i[index]
      end
      resources :students, only: %i[index show create]
      resources :teachers, only: %i[index show create edit update]
    end

    # 生徒用のpath
    namespace :students do
      resources :achievements, only: %i[index show]
      resources :problems, only: %i[index show] do
        resources :achievements, only: %i[create]
        resources :questions, only: %i[index]
      end
      resources :students, only: %i[show edit update]
    end
  end
end
