Rails.application.routes.draw do
  root to: 'pages#home', id: 'home'
  resources 'boards'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
