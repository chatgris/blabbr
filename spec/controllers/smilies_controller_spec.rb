require 'spec_helper'

describe SmiliesController do

  let(:user)    {mock_user}
  let(:smiley)  {mock_smiley}
  let(:smilies) {[smiley]}

  describe 'current_user == added_by' do

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    describe 'POST create' do
      before :each do
        Smiley.should_receive(:new).with({'new' => 'smiley'}).and_return(smiley)
        smiley.should_receive(:added_by=).with(user.nickname).and_return(smiley)
      end

      context 'with valid params' do
        before :each do
          smiley.should_receive(:save).and_return(true)
          post :create, :smiley => {'new' => 'smiley'}, :format => :json
        end

        it 'should assigns smiley' do
          assigns(:smiley).should == smiley
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('smilies.create.success')
        end
      end

      context 'without valid params' do
        before :each do
          smiley.should_receive(:save).and_return(false)
          post :create, :smiley => {'new' => 'smiley'}, :format => :json
        end

        it 'should assigns smiley' do
          assigns(:smiley).should == smiley
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('smilies.create.fail')
        end
      end
    end

    describe 'GET index' do
      before :each do
        Smiley.should_receive(:all).and_return(smilies)
        get :index, :format => :json
      end

      it 'should assign smilies' do
        assigns(:smilies).should == smilies
      end

      it 'get new should be success' do
        response.should be_success
      end
    end

    describe 'PUT update' do
      before :each do
        Smiley.should_receive(:criteria).and_return(smiley)
        smiley.should_receive(:for_ids).with(smiley.id).and_return(smiley)
        smiley.should_receive(:by_nickname).with(user.nickname).and_return(smiley)
        smiley.should_receive(:first).and_return(smiley)
      end

      context 'with valid params' do
        before :each do
          smiley.should_receive(:update_attributes).with({'update' => 'smiley'}).and_return(true)
          put :update, :id => smiley.id, :smiley => {'update' => 'smiley'}, :format => :json
        end

        it 'should assigns topic' do
          assigns(:smiley).should == smiley
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('smilies.update.success')
        end
      end

      context 'without valid params' do
        before :each do
          smiley.should_receive(:update_attributes).with({'update' => 'smiley'}).and_return(false)
          put :update, :id => smiley.id, :smiley => {'update' => 'smiley'}, :format => :json
        end

        it 'should assigns topic' do
          assigns(:smiley).should == smiley
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('smilies.update.fail')
        end
      end

    end

    describe 'DELETE :destroy' do

      before :each do
        Smiley.should_receive(:criteria).and_return(smiley)
        smiley.should_receive(:for_ids).with(smiley.id).and_return(smiley)
        smiley.should_receive(:by_nickname).with(user.nickname).and_return(smiley)
        smiley.should_receive(:first).and_return(smiley)
      end

      context 'with valid params' do

        before :each do
          smiley.should_receive(:destroy).and_return(true)
          delete :destroy, :id => smiley.id, :format => :json
        end

        it 'should have a notice message' do
          flash[:notice].should == I18n.t('smilies.destroy.success')
        end

      end

      context 'without valid params' do

        before :each do
          smiley.should_receive(:destroy).and_return(false)
          delete :destroy, :id => smiley.id, :format => :json
        end

        it 'should have a notice message' do
          flash[:alert].should == I18n.t('smilies.destroy.fail')
        end

      end
    end

  end

end
