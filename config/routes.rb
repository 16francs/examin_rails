Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]
    resources :users, only: %i[] do
      post 'check_unique', on: :collection
    end

    namespace :students do
      resources :problems, only: %i[index]
    end

    namespace :teachers do
      resources :problems, only: %i[index]
      resources :students, only: %i[create]
      resources :teachers, only: %i[index create]
    end
  end
end
