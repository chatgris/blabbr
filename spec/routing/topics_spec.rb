require 'spec_helper'

describe "routing to topics" do
  context "get request" do
    it "routes /topics to topics#index" do
      pending
      { :get => "/topics"}.should route_to(
        :controller => "topics",
        :action => "index"
      )
    end

    it "routes /topics/:id to topics#show for id" do
      pending
      { :get => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "show",
        :id => ":id"
      )
    end

    it "routes /topics/:id/edit to topics#edit for id" do
      pending
      { :get => "/topics/:id/edit"}.should route_to(
        :controller => "topics",
        :action => "edit",
        :id => ":id"
      )
    end

    it "routes /topics/new to topics#new" do
      pending
      { :get => "/topics/new"}.should route_to(
        :controller => "topics",
        :action => "new"
      )
    end

    context "pagination" do
      it "routes /topics/:id/page/:page to topics#show" do
        pending
        { :get => "/topics/:id/page/:page"}.should route_to(
          :controller => "topics",
          :action => "show",
          :id => ":id",
          :page => ":page"
        )
      end
    end

  end

  context "post request" do
    it "routes /topics/ to topics#create" do
      pending
      { :post => "/topics"}.should route_to(
        :controller => "topics",
        :action => "create"
      )
    end

  end

  context "put request" do
    it "routes /topics/:id to topics#update for id" do
      pending
      { :put => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "update",
        :id => ":id"
      )
    end
  end

  context "delete request" do
    it "routes /topics/:id to topics#destroy for id" do
      pending
      { :delete => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "destroy",
        :id => ":id"
      )
    end
  end

end
