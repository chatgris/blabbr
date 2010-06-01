require 'spec_helper'

describe TopicsController do

  describe "GET index" do
    describe "auth" do
      it "shouldn't show index to an unregistred user"
    end
    it "assigns all topics as @topics"
  end

  describe "GET show" do
    describe "auth" do
      it "shouldn't show topic to a user who doesn't belongs to members"
    end

    it "assigns the requested topic as @topic"
  end

  describe "GET new" do
    describe "auth" do
      it "shouldn't show new to an unregistred user"
    end

    it "assigns a new topic as @topic"
  end

  describe "GET edit" do
    describe "auth" do
      it "should allow only to the creator of topic"
    end

    it "assigns the requested topic as @topic"
  end

  describe "POST create" do

    describe "with valid params" do

      it "redirects to the created topic"
    end

    describe "with invalid params" do

      it "re-renders the 'new' template"
    end

  end

  describe "PUT update" do

    describe "auth" do
      it "should allow only to the creator of topic"
    end

    describe "with valid params" do
      it "updates the requested topic"

      it "redirects to the topic"
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template"
    end

  end

  describe "DELETE destroy" do

    describe "auth" do
      it "should allow only to the creator of topic"
    end

    it "destroys the requested topic"

    it "redirects to the topics list"
  end

end
