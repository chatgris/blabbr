Blabbr::Application.routes.draw do |map|
  resources :sessions
  resources :users
  match '/topics/page/:page' => 'topics#index'
  match '/topics/:id/page/:page' => 'topics#show'
  resources :topics do
    member do
      put :add_subscriber
      delete :remove_subscriber
    end
    resources :posts
  end
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'home' => 'users#edit', :as => :home
  root :to => 'topics#index'
end
