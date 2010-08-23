require 'spec_helper'

describe "routing to members" do

  context "post request" do
    it "routes /topics/:topic_id/members to topics#create" do
      { :post => "/topics/:topic_id/members"}.should route_to(
        :controller => "members",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end
  end

  context "delete request" do
    it "routes /topics/:topic_id/members/:id to topics#destroy" do
      { :delete => "/topics/:topic_id/members/:id"}.should route_to(
        :controller => "members",
        :action => "destroy",
        :topic_id => ":topic_id",
        :id => ":id"
      )
    end
  end

end
