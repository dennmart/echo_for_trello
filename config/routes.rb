Rails.application.routes.draw do
  root 'site#index'

  resources 'boards'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
