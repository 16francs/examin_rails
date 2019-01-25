Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[create]
  end
end
