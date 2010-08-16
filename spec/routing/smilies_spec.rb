require 'spec_helper'

describe "routing to smilies" do
  context "get request" do
    it "routes /smilies to smilies#index" do
      { :get => "/smilies"}.should route_to(
        :controller => "smilies",
        :action => "index"
      )
    end

    it "does not expose smilies#show" do
      { :get => "/smilies/chatgris" }.should_not be_routable
    end

    it "routes /smilies/:id/edit to smilies#edit for id" do
      { :get => "/smilies/:id/edit"}.should route_to(
        :controller => "smilies",
        :action => "edit",
        :id => ":id"
      )
    end
  end

  context "post request" do
    it "routes /smilies to smilies#create" do
      { :post => "/smilies"}.should route_to(
        :controller => "smilies",
        :action => "create"
      )
    end
  end

  context "put request" do
    it "routes /smilies/:id to smilies#update for id" do
      { :put => "/smilies/:id"}.should route_to(
        :controller => "smilies",
        :action => "update",
        :id => ":id"
      )
    end
  end

  context "delete request" do
     it "routes /smilies/:id to smilies#destroy for id" do
      { :delete => "/smilies/:id"}.should route_to(
        :controller => "smilies",
        :action => "destroy",
        :id => ":id"
      )
    end
  end

end
