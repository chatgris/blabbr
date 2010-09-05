Blabbr::Application.routes.draw do

  devise_for :users

  authenticate :user do
    match "/uploads/*path" => "gridfs#serve"

    resources :users, :except => [:edit, :destroy] do
      get :autocomplete, :on => :collection
    end

    resources :smilies, :as => "smileys", :except => [:show]

    match '/topics/:id/page/:page' => 'topics#show', :as => "page_topic"

    resources :topics do
      resources :posts
      resources :members, :only => [:create, :destroy]
    end

    match 'dashboard' => 'users#edit', :as => :dashboard

    root :to => 'topics#index'
  end

end
