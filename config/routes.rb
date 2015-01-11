Rails.application.routes.draw do
  root 'site#index'

  get 'boards', to: 'boards#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
