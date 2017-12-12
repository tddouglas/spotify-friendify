Rails.application.routes.draw do
  root 'welcome#index'
  resources :comments, except: [:index, :show]
  resources :users do
    member do
      delete 'remove_friendship'
      post 'send_friend_request'
      patch 'accept_friend_request'
    end
    get '/songs', to: 'songs#all'
    get '/artists', to: 'artists#all'
  end
  get '/auth/:provider/callback', to: 'sessions#create'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  get 'friend_requests', to: 'users#friend_requests'
end