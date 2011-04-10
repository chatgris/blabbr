require 'spec_helper'

describe "routing to users" do
  context "get request" do
    it "routes /users to users#index" do
      pending
      { :get => "/users" }.should route_to(
        :controller => "users",
        :action => "index"
      )
    end

    it "routes /users/new to users#new" do
      pending
      { :get => "/users/new" }.should route_to(
        :controller => "users",
        :action => "new"
      )
    end

    it "routes /users/:nickname to users#show for nickname" do
      pending
      { :get => "/users/chatgris" }.should route_to(
        :controller => "users",
        :action => "show",
        :id => "chatgris"
      )
    end

    it "routes /dashboard to users#edit" do
      pending
      { :get => "/dashboard" }.should route_to(
        :controller => "users",
        :action => "edit"
      )
    end

    it "does not expose users#edit" do
      pending
      { :get => "/users/chatgris/edit" }.should_not be_routable
    end
  end

  context "post request" do
    it "routes /users to users#create" do
      pending
      { :post => "/users" }.should route_to(
        :controller => "devise/registrations",
        :action => "create"
      )
    end
  end

  context "put request" do
    it "routes /users/:id to users#update" do
      pending
      { :put => "/users/:id" }.should route_to(
        :controller => "users",
        :action => "update",
        :id => ":id"
      )
    end
  end

  context "delete request" do
    it "does not expose users#destroy" do
      pending
      {:delete => "/users/chatgris"}.should_not be_routable
    end
  end

end
