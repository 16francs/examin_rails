Rails.application.routes.draw do
  namespace :api, { format: :json } do
    # 共通のpath
    get    '/auth', to: 'auth#show'
    post   '/auth', to: 'auth#create'
    delete '/auth', to: 'auth#destroy'
    post '/users/check_unique',     to: 'users#check_unique'
    post '/users/:id/check_unique', to: 'users#check_unique'
    put  '/users', to: 'users#update'

    # 講師用のpath
    namespace :teachers do
      resources :problems, only: %i[index show create edit update] do
        resources :questions, only: %i[index show create edit update destroy]
      end
      resources :problems_users, only: %i[index show]
      resources :students, only: %i[index show create edit update]
      resources :teachers, only: %i[index show create edit update]
    end

    # 生徒用のpath
    namespace :students do
      resources :problems, only: %i[index show] do
        post 'achievement', on: :member
        resources :questions, only: %i[index] do
          get 'random', on: :collection
        end
      end
      resources :problems_users, only: %i[index show]
    end
  end
end
