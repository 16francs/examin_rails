Rails.application.routes.draw do
  namespace :api, { format: :json } do
    resources :auth, only: %i[index create]
  end
end
