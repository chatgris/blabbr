require 'spec_helper'

describe "routing to sessions" do
  context "get request" do
    it "routes /login to sessions#new" do
      { :get => "/login"}.should route_to(
        :controller => "sessions",
        :action => "new"
      )
    end

    it "does not expose sessions#new" do
      { :get => "/sessions/new" }.should_not be_routable
    end

    it "does not expose sessions#edit" do
      { :get => "/sessions/:id/edit" }.should_not be_routable
    end

    it "does not expose sessions#show" do
      { :get => "/sessions/:id" }.should_not be_routable
    end
  end

  context "post request" do
    it "routes /login to sessions#create" do
      { :post => "/sessions"}.should route_to(
        :controller => "sessions",
        :action => "create"
      )
    end
  end

  context "put request" do
    it "does not expose sessions#update" do
      { :put => "/sessions/:id" }.should_not be_routable
    end
  end

  context "delete request" do
    it "does not expose sessions#destroy" do
      {:delete => "/sessions"}.should_not be_routable
    end

    it "routes /logout to sessions#destroy" do
      { :get => "/logout"}.should route_to(
        :controller => "sessions",
        :action => "destroy"
      )
    end
  end

end
