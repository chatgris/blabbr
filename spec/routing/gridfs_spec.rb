# encoding: utf-8
require 'spec_helper'

describe "routing to gridfs" do
    it "routes /uploads/*path to gridfs#serve" do
      pending
      { :get => "/uploads/smilies/image.gif" }.should route_to(
        :controller => "gridfs",
        :action => "serve",
        :path => "smilies/image.gif"
      )
    end
end
