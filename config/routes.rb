require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'pages#home', id: 'home'

  resources 'cards', only: [:index]

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/admin', to: 'admin#index'
end
