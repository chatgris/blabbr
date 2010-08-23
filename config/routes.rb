Blabbr::Application.routes.draw do
  match "/uploads/*path" => "gridfs#serve"
  resources :sessions, :only => [:create]
  resources :users, :except => [:edit, :destroy]
  resources :smilies, :as => "smileys", :except => [:show]
  #match '/topics/page/:page' => 'topics#index'
  match '/topics/:id/page/:page' => 'topics#show', :as => "page_topics"
  resources :topics do
    resources :posts
    member do
      put :add_member, :add_post
      delete :remove_member
    end
  end
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'dashboard' => 'users#edit', :as => :dashboard
  root :to => 'topics#index'
end
