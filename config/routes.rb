Blabbr::Application.routes.draw do |map|
  match "/uploads/*path" => "gridfs#serve"
  resources :sessions
  resources :users
  resources :smilies, :as => "smileys"
  match '/topics/page/:page' => 'topics#index'
  match '/topics/:id/page/:page' => 'topics#show'
  resources :topics do
    member do
      put :add_member, :add_post
      delete :remove_member
    end
    resources :posts
  end
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'home' => 'users#edit', :as => :home
  root :to => 'topics#index'
end
