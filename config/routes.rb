Rails.application.routes.draw do
  root 'welcome#index'
  resources :users do
    member do
      delete 'remove_friendship'
      post 'send_friend_request'
      patch 'accept_friend_request'
    end
    get '/songs', to: 'songs#all'
    get '/artists', to: 'artists#all'
    resources :songs, except: [:edit, :update]
    resources :artists, except: [:edit, :update] do
      member do
        get 'related_artists'
        get 'top_tracks'
      end
    end
  end
  get '/auth/:provider/callback', to: 'sessions#create'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  get 'friend_requests', to: 'users#friend_requests'
end