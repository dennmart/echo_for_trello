require 'sidekiq/web'

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
  get '/admin', to: 'admin#index'

  get '/faq', to: 'pages#faq'
  get '/terms_and_conditions', to: 'pages#terms_and_conditions'
  get '/privacy_policy', to: 'pages#privacy_policy'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?

  mount Sidekiq::Web => '/sidekiq'
end
