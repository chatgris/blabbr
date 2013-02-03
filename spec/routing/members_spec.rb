# encoding: utf-8
require 'spec_helper'

describe "routing to members" do

  context "post request" do
    it "routes /topics/:topic_id/members to topics#create" do
      pending
      { :post => "/topics/:topic_id/members"}.should route_to(
        :controller => "members",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end
  end

  context "delete request" do
    it "routes /topics/:topic_id/members/:id to topics#destroy" do
      pending
      { :delete => "/topics/:topic_id/members/:id"}.should route_to(
        :controller => "members",
        :action => "destroy",
        :topic_id => ":topic_id",
        :id => ":id"
      )
    end
  end

end
