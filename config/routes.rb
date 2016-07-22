Rails.application.routes.draw do
  root "application#index"
  get '/register', to: "users#new"
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  resources :users, except: [:new, :index]
  resources :articles, only: [:new, :create]
end
