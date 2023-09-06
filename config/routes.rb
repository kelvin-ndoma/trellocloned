Rails.application.routes.draw do
  get 'sessions/create'
  post "/signup", to: "users#create"
  get "/me", to: "users#show"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :boards do
    resources :lists do
      resources :cards do
        resources :tasks
      end
    end
  end
end
