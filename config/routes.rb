Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    get    '/auth', to: 'auth#show'
    post   '/auth', to: 'auth#create'
    put    '/auth', to: 'auth#update'
    delete '/auth', to: 'auth#destroy'

    # 講師用のpath
    namespace :teachers do
      resources :problems, only: %i[index show create edit update] do
        post 'check_unique', on: :collection
        post 'check_unique', on: :member
        resources :questions, only: %i[index]
      end
      resources :problems_users, only: %i[index show]
      resources :students, only: %i[index show create edit update] do
        post 'check_unique', on: :collection
        post 'check_unique', on: :member
      end
      resources :teachers, only: %i[index show create edit update] do
        post 'check_unique', on: :collection
        post 'check_unique', on: :member
      end
    end

    # 生徒用のpath
    namespace :students do
      resources :problems, only: %i[index show] do
        post 'achievement', on: :member

        resources :problems_users, only: %i[create]
        resources :questions, only: %i[index] do
          get 'random', on: :collection
        end
      end
      resources :problems_users, only: %i[index show]
      resources :students, only: %i[show edit update]
    end
  end
end
