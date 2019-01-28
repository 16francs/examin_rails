Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]

    namespace :students do
    end

    namespace :teachers do
      resources :teachers, only: %i[create]
    end
  end
end
