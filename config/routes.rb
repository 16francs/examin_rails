Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]
    resources :users, only: %i[] do
      get 'me', on: :collection, to: 'users#show_me'
      patch 'me', on: :collection, to: 'users#update_me'
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
        get 'download', on: :collection, to: 'problems#download_template'
        resources :questions, only: %i[index create] do
          post 'upload', on: :collection, to: 'questions#create_many'
        end
      end
      resources :students, only: %i[index create]
      resources :teachers, only: %i[index create]
    end
  end
end
