Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]
    resources :users, only: %i[] do
      post 'check_unique', on: :collection
    end

    namespace :students do
      resources :problems, only: %i[index] do
        resources :questions, only: %i[index] do
          get 'random', on: :collection
        end
      end
    end

    namespace :teachers do
      resources :problems, only: %i[index create]
      resources :students, only: %i[create]
      resources :teachers, only: %i[index create]
    end
  end
end
