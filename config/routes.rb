Blabbr::Application.routes.draw do

  devise_for :users do
    get "/logout" => "devise/sessions#destroy", :as => :logout
  end

  authenticate :user do
    match "/uploads/*path" => "gridfs#serve"

    resources :users, :only => [:show, :create, :update] do
      collection do
        get :autocomplete
        get :current
      end
    end

    resources :smilies, :as => "smileys", :except => [:show]

    match '/topics/:id/page/:page' => 'topics#show', :as => "page_topic"
    match '/topics/page/:page' => 'topics#index', :as => "page_topics"

    resources :topics do
      resources :posts
      put :add_member, :on => :member
      put :rm_member, :on => :member
    end

    match 'dashboard' => 'users#edit', :as => :dashboard

    root :to => 'topics#index'
  end

end
