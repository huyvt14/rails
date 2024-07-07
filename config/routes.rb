Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  
  resources :products
  get 'demo_partials/new'
  get 'demo_partials/edit'
  get 'static_pages/home'
  get 'static_pages/help'

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(new create show)

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
