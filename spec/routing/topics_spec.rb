require 'spec_helper'

describe "routing to topics" do
  context "get request" do
    it "routes /topics to topics#index" do
      { :get => "/topics"}.should route_to(
        :controller => "topics",
        :action => "index"
      )
    end

    it "routes /topics/:id to topics#show for id" do
      { :get => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "show",
        :id => ":id"
      )
    end

    it "routes /topics/:id/edit to topics#edit for id" do
      { :get => "/topics/:id/edit"}.should route_to(
        :controller => "topics",
        :action => "edit",
        :id => ":id"
      )
    end

    it "routes /topics/new to topics#new" do
      { :get => "/topics/new"}.should route_to(
        :controller => "topics",
        :action => "new"
      )
    end

    context "pagination" do
      it "routes /topics/:id/page/:page to topics#show" do
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
      { :post => "/topics"}.should route_to(
        :controller => "topics",
        :action => "create"
      )
    end

    it "routes /topics/:topic_id/posts to topics#create" do
      { :post => "/topics/:topic_id/posts"}.should route_to(
        :controller => "posts",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end

  end

  context "put request" do
    it "routes /topics/:id to topics#update for id" do
      { :put => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "update",
        :id => ":id"
      )
    end

    it "routes /topics/:id/add_member to topics#add_post" do
      { :put => "/topics/:id/add_post"}.should route_to(
        :controller => "topics",
        :action => "add_post",
        :id => ":id"
      )
    end

    it "routes /topics/:id/add_member to topics#add_member" do
      { :put => "/topics/:id/add_member"}.should route_to(
        :controller => "topics",
        :action => "add_member",
        :id => ":id"
      )
    end
  end

  context "delete request" do
    it "routes /topics/:id to topics#destroy for id" do
      { :delete => "/topics/:id"}.should route_to(
        :controller => "topics",
        :action => "destroy",
        :id => ":id"
      )
    end
  end

end
