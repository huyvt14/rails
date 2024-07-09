Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'password_resets/create'
  get 'password_resets/update'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users
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
  # chuyen delete -> get "/logout", to: "sessions#destroy"
  get "/logout", to: "sessions#destroy"


  root to: 'static_pages#home'
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new create edit update)
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
