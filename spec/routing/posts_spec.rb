require 'spec_helper'

describe "routing to posts" do
  context "get request" do
    it "routes /topics/:topic_id/posts/:id/edit to posts#edit" do
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
      { :post => "/topics/:topic_id/posts"}.should route_to(
        :controller => "posts",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end
  end

end
