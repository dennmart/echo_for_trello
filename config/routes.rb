Rails.application.routes.draw do
  root to: 'pages#home', id: 'home'
  resources 'boards' do
    member do
      post 'new_list'
    end
  end
  resources 'cards' do
    member do
      put 'update_status'
    end

    collection do
      get 'logs'
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
