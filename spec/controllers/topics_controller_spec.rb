require 'spec_helper'

describe TopicsController do

  describe 'with creator as current_user' do

    let(:topic) { mock_topic}
    let(:topics) {[mock_topic]}
    let(:one_post) {mock_post}
    let(:posts) {[mock_post]}
    let(:user) {mock_user}

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    describe 'GET new' do
      before :each do
        Topic.should_receive(:new).and_return(topic)
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:new).and_return(posts)
        get :new
      end

      it 'should assign topic' do
        assigns(:topic).should == topic
      end

      it 'get new should be success' do
        response.should be_success
      end
    end

    describe 'GET index' do
      before :each do
        Topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topics)
        topics.should_receive(:desc).and_return(topics)
        topics.should_receive(:paginate).and_return(topics)
        get :index
      end

      it 'get new should be success' do
        response.should be_success
      end

      it 'should assigns topics' do
        assigns(:topics).should == topics
      end
    end

    describe 'GET show' do
      before :each do
        Topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topic)
        topic.should_receive(:first).and_return(topic)
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:asc).and_return(posts)
        posts.should_receive(:paginate)
        topic.should_receive(:reset_unread)
        get :show, :id => topic.id
      end

      it 'get new should be success' do
        response.should be_success
      end

      it 'should assigns topic' do
        assigns(:topic).should == topic
      end
    end

    describe 'GET edit' do
      before :each do
        Topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topic)
        topic.should_receive(:find).with(topic.id).and_return(topic)
        get :edit, :id => topic.id
      end

      it 'get new should be success' do
        response.should be_success
      end

      it 'should assigns topic' do
        assigns(:topic).should == topic
      end
    end

    describe 'POST create' do
      before :each do
        Topic.should_receive(:new).with({'new' => 'topic'}).and_return(topic)
        topic.should_receive(:user=).and_return(user)
      end

      context 'with valid params' do
        before :each do
          topic.should_receive(:save).and_return(true)
          post :create, :topic => {'new' => 'topic'}
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('topics.create.success')
        end
      end

      context 'with invalid params' do
        before :each do
          topic.should_receive(:save).and_return(false)
          Post.should_receive(:new).and_return(:one_post)
          post :create, :topic => {'new' => 'topic'}
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should render the new template' do
          response.should render_template(:new)
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('topics.create.fail')
        end
      end
    end


    describe 'PUT update' do
      before :each do
        Topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topic)
        topic.should_receive(:find).with(topic.id).and_return(topic)
      end

      context 'with valid params' do
        before :each do
          topic.should_receive(:update_attributes).with('new' => 'topic').and_return(true)
          put :update, :id => topic.id, :topic => {'new' => 'topic'}
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic.slug)
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('topics.update.success')
        end
      end

      context 'with invalid params' do
        before :each do
          topic.should_receive(:update_attributes).with('new' => 'topic').and_return(false)
          put :update, :id => topic.id, :topic => {'new' => 'topic'}
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('topics.update.fail')
        end
      end
    end

    describe 'DELETE destroy' do
      before :each do
        Topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topic)
        topic.should_receive(:find).with(topic.id).and_return(topic)
        topic.should_receive(:destroy)
        delete :destroy, :id => topic.id
      end

      it 'redirect to back' do
        response.should redirect_to(:back)
      end

      it 'should have a notice message' do
        flash[:notice].should == I18n.t('topics.deleted')
      end
    end

   # it 'should delete the topic' do
   #   lambda do
   #     delete :destroy, :id => @topic.id
   #   end.should change(Topic, :count).by(-1)
   #   Topic.criteria.id(@topic.id).first.should be_nil
   #   response.should redirect_to :back
   # end

  end

 # describe 'with a logged user as current_user, not a member' do

 #   before :each do
 #     @creator = Factory.create(:creator)
 #     @topic = Factory.create(:topic)
 #     @current_user = Factory.create(:user)
 #     controller.stub!(:logged_in?).and_return(true)
 #     controller.stub!(:current_user).and_return(@current_user)
 #     request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
 #   end

 #   it 'should not see topic' do
 #     get :show, :id => @topic.slug
 #     response.should redirect_to :back
 #     flash[:alert].should == I18n.t('topic.not_auth')
 #   end

 #   it 'should not see edit' do
 #     get :edit, :id => @topic.id
 #     response.should redirect_to :back
 #     flash[:alert].should == I18n.t('topic.not_auth')
 #   end

 #   it 'get new should be success' do
 #     get :new
 #     response.should be_success
 #   end

 #   it 'should not delete the topic' do
 #     lambda do
 #       delete :destroy, :id => @topic.id
 #     end.should_not change(Topic, :count).by(-1)
 #     response.should redirect_to :back
 #     flash[:alert].should == I18n.t('topic.not_auth')
 #   end

 # end

 # describe 'with a logged user as current_user, current_user is a member' do

 #   before :each do
 #     @creator = Factory.create(:creator)
 #     @topic = Factory.create(:topic)
 #     @current_user = Factory.create(:user)
 #     @topic.new_member(@current_user.nickname)
 #     controller.stub!(:logged_in?).and_return(true)
 #     controller.stub!(:current_user).and_return(@current_user)
 #     request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
 #   end

 #   it 'should see topic' do
 #     get :show, :id => @topic.slug
 #     response.should be_success
 #   end

 #   it 'should not see edit' do
 #     get :edit, :id => @topic.id
 #     response.should redirect_to :back
 #     flash[:alert].should == I18n.t('topic.not_auth')
 #   end

 #   it 'should not delete the topic' do
 #     lambda do
 #       delete :destroy, :id => @topic.id
 #     end.should_not change(Topic, :count).by(-1)
 #     response.should redirect_to :back
 #     flash[:alert].should == I18n.t('topic.not_auth')
 #   end

 # end

end
