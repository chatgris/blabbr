ActionController::Routing::Routes.draw do |map|
  map.resources :sessions
  map.resources :topics, :has_many => :posts
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'

  map.root :controller => 'sessions', :action => 'new'
end

