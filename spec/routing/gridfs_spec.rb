require 'spec_helper'

describe "routing to gridfs" do
    it "routes /uploads/*path to gridfs#serve" do
      { :get => "/uploads/smilies/image.gif" }.should route_to(
        :controller => "gridfs",
        :action => "serve",
        :path => "smilies/image.gif"
      )
    end
end
