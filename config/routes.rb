Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]
    resources :users, only: %i[] do
      get 'me', on: :collection, to: 'users#show_me'
      post 'me', on: :collection, to: 'users#update_me'
      post 'check_unique', on: :collection
    end

    namespace :students do
      resources :problems, only: %i[index show] do
        post 'achievement', on: :member
        resources :questions, only: %i[index] do
          get 'random', on: :collection
        end
      end
      resources :problems_users, only: %i[index show]
    end

    namespace :teachers do
      resources :problems, only: %i[index create] do
        resources :questions, only: %i[index create]
      end
      resources :students, only: %i[create]
      resources :teachers, only: %i[index create]
    end
  end
end
