require 'spec_helper'

describe UsersController do

  describe "GET show" do
    describe "auth" do
      it "shouldn't show user to an anonymous user"
    end

    it "assigns the requested user as @user"
  end

  describe "GET edit" do
    describe "auth" do
      it "should allow only to the current user"
    end

    it "assigns the requested user as @user"
  end

  describe "POST create" do

    describe "with valid params" do

      it "redirects to the topics index"
    end

    describe "with invalid params" do

      it "re-renders the 'new' template"
    end

  end

  describe "PUT update" do

    describe "auth" do
      it "should allow only to the current user"
    end

    describe "with valid params" do
      it "updates the requested user"

      it "redirects to the user"
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template"
    end

  end

end
