require 'spec_helper'

describe MembersController do

  let(:topic)    {mock_topic}
  let(:topics)   {[mock_topic]}
  let(:one_post) {mock_post}
  let(:posts)    {[mock_post]}
  let(:user)     {mock_user}
  let(:member)   {mock_user}

  before :each do
    controller.stub!(:logged_in?).and_return(true)
    controller.stub!(:current_user).and_return(user)
    request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
  end

  describe 'with creator as current_user' do

    before :each do
      Topic.should_receive(:for_creator).with(user.nickname).and_return(topic)
      topic.should_receive(:find).with(topic.id).and_return(topic)
    end

    describe 'POST create' do

      context 'with valid params' do
        before :each do
          topic.should_receive(:new_member).and_return(true)
          post :create, :topic_id => topic.id, :nickname => member.nickname
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('members.create.success')
        end
      end

      context 'without valid params' do
        before :each do
          topic.should_receive(:new_member).and_return(false)
          post :create, :topic_id => topic.id, :nickname => member.nickname
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('members.create.fail')
        end

      end
    end

    describe 'DELETE destroy' do
      context 'with valid params' do
        before :each do
          topic.should_receive(:rm_member!).with(member.id).and_return(true)
          delete :destroy, :topic_id => topic.id, :id => member.id
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('members.destroy.success')
        end
      end

      context 'without valid params' do
        before :each do
          topic.should_receive(:rm_member!).with(member.id).and_return(false)
          delete :destroy, :topic_id => topic.id, :id => member.id
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('members.destroy.fail')
        end
      end
    end

  end

  describe 'with a logged user as current_user, not a member' do

    before :each do
      Topic.should_receive(:for_creator).with(user.nickname).and_return(topic)
      topic.should_receive(:find).with(topic.id).and_return(nil)
    end

    describe 'POST create' do
      before :each do
        topic.should_not_receive(:new_member)
        post :create, :topic_id => topic.id, :nickname => member.nickname
      end

      it 'should be redirect' do
        response.should redirect_to(:back)
      end

      it 'should have a notice' do
        flash[:alert].should == I18n.t('topics.not_auth')
      end

    end

    describe 'DELETE destroy' do
      before :each do
        delete :destroy, :topic_id => topic.id, :id => member.id
      end

      it 'should be redirect' do
        response.should redirect_to(:back)
      end

      it 'should have a notice' do
        flash[:alert].should == I18n.t('topics.not_auth')
      end

    end
  end

end
