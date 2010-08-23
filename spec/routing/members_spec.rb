require 'spec_helper'

describe "routing to members" do

context "post request" do
    it "routes /topics/:topic_id/members to topics#create" do
      { :post => "/topics/:topic_id/members"}.should route_to(
        :controller => "posts",
        :action => "create",
        :topic_id => ":topic_id"
      )
    end
  end

end
