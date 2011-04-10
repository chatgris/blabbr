require 'spec_helper'

describe "routing to posts" do
  context "get request" do
    it "routes /topics/:topic_id/posts/:id/edit to posts#edit" do
      pending
      { :get => "/topics/:topic_id/posts/:id/edit"}.should route_to(
        :controller => "posts",
        :action => "edit",
        :topic_id => ":topic_id",
        :id => ":id"
      )
    end
  end

  context "post request" do
    it "routes /topics/:topic_id/posts to topics#create" do
      pending
      { :post => "/topics/:topic_id/posts"}.should route_to(
        :controller => "posts",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end
  end

  context "put request" do
    it "routes /topics/:topic_id/posts/:id to topics#create" do
      pending
      { :put => "/topics/:topic_id/posts/:id"}.should route_to(
        :controller => "posts",
        :action => "update",
        :topic_id => ":topic_id",
        :id => ":id"
      )
    end
  end

end
