require 'spec_helper'

describe SmiliesController do

  describe 'current_user == added_by' do

    before :each do
      @current_user = Factory.create(:user)
      @smiley = Factory.create(:smiley)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it 'should be able to see index' do
      get :index
      response.should be_success
    end

    it 'should create a smiley' do
      post :create, :smiley => {:code => 'test', :image => File.open(Rails.root.join("image.jpg"))}
      response.should redirect_to root_path
      Smiley.all.size.should == 2
      Smiley.last.image.url.should == "/uploads/smilies/test.jpg"
    end

    it 'get new should be success' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      get :new
      response.should be_success
    end

    it 'should see edit' do
      get :edit, :id => @smiley.id
      response.should be_success
    end

    it 'should update smiley if current_user is user' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      put :update, :smiley => {:code => 'code', :image => File.open(Rails.root.join("image.jpg"))}, :id => @smiley.id
      response.should redirect_to :back
      @smiley.reload.code.should == 'code'
      @smiley.reload.image.filename.should == "code.jpg"
    end

    it 'should delete the smiley' do
      lambda do
        delete :destroy, :id => @smiley.id
      end.should change(Smiley, :count).by(-1)
      Topic.criteria.id(@smiley.id).first.should be_nil
      response.should redirect_to topics_path
    end

  end

  describe 'current_user != added_by' do

    before :each do
      @current_user = Factory.create(:creator)
      @smiley = Factory.create(:smiley)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should not see edit' do
      get :edit, :id => @smiley.id
      response.should redirect_to :back
      flash[:alert].should == I18n.t('smilies.not_auth')
    end

    it 'should not update smiley' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      put :update, :smiley => {:code => 'code'}, :id => @smiley.id
      response.should redirect_to :back
      @smiley.reload.code.should_not == 'code'
      flash[:alert].should == I18n.t('smilies.not_auth')
    end

    it 'should not delete the smiley' do
      lambda do
        delete :destroy, :id => @smiley.id
      end.should_not change(Smiley, :count).by(-1)
      response.should redirect_to :back
      flash[:alert].should == I18n.t('smilies.not_auth')
    end

  end

end
