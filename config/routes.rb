Rails.application.routes.draw do

  root "application#index"
  get '/register', to: "users#new"
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get '/new-password', to:"users#password"
  patch '/password', to:"users#update_password"

  resources :users, except: [:new, :index] 
  resources :articles, only: [:new, :create]
  resources :audios

end
