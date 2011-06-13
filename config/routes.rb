class JsonConstraint
  def matches?(request)
    request.format.json?
  end
end
Blabbr::Application.routes.draw do

  devise_for :users do
    get "/logout" => "devise/sessions#destroy", :as => :logout
  end

  authenticate :user do
    constraints JsonConstraint.new do

      resources :users, :only => [:show, :create, :update], :constraints => JsonConstraint.new do
        collection do
          get :autocomplete
          get :current
        end
      end

      resources :smilies, :as => "smileys", :except => [:show, :edit]

      match '/topics/:id/page/:page' => 'topics#show', :as => "page_topic"
      match '/topics/page/:page' => 'topics#index', :as => "page_topics"

      resources :topics do
        resources :posts do
          member do
            put :publish
          end
        end
      end

      match 'dashboard' => 'users#edit', :as => :dashboard

      root :to => 'topics#index'
    end
    match "/uploads/*path" => "gridfs#serve"
    root :to => 'home#index'
    match '*a', :to => 'home#index'
  end

end
