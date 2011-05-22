require 'spec_helper'

describe TopicsController do

  let(:topic) { mock_topic}
  let(:topics) {[mock_topic]}
  let(:one_post) {mock_post}
  let(:posts) {[mock_post]}
  let(:member)   {mock_user}
  let(:user)   {mock_user}

  describe 'with creator as current_user' do

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can :manage, Topic
      @controller.stub!(:current_ability).and_return(@ability)
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
        topics.should_receive(:page).and_return(topics)
        topics.should_receive(:current_page).at_least(:once).and_return(1)
        topics.should_receive(:num_pages).at_least(:once).and_return(1)
        topics.should_receive(:limit_value).at_least(:once).and_return(1)
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
        Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
        topic.should_receive(:first).and_return(topic)
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:asc).and_return(posts)
        posts.should_receive(:page).and_return(posts)
        posts.should_receive(:current_page).at_least(:once).and_return(1)
        posts.should_receive(:num_pages).at_least(:once).and_return(1)
        posts.should_receive(:limit_value).at_least(:once).and_return(1)
        topic.should_receive(:reset_unread)
        get :show, :id => topic.slug
      end

      it 'get new should be success' do
        response.should be_success
      end

      it 'should assigns topic' do
        assigns(:topic).should == topic
      end

      it 'should assigns posts' do
        assigns(:posts).should == posts
      end
    end

    describe 'GET edit' do
      before :each do
        Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
        topic.should_receive(:first).and_return(topic)
        get :edit, :id => topic.slug
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
          topic.should_receive(:posts).and_return(posts)
          posts.should_receive(:page).and_return(posts)
          post :create, :topic => {'new' => 'topic'}
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic)
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
          post :create, :topic => {'new' => 'topic'}
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('topics.create.fail')
        end
      end
    end


    describe 'PUT update' do
      before :each do
        Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
        topic.should_receive(:first).and_return(topic)
      end

      context 'with valid params' do
        before :each do
          topic.should_receive(:update_attributes).with('new' => 'topic').and_return(true)
          put :update, :id => topic.slug, :topic => {'new' => 'topic'}
        end

        it 'should be redirect' do
          response.should redirect_to topic_path(topic)
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
          put :update, :id => topic.slug, :topic => {'new' => 'topic'}
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
        Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
        topic.should_receive(:first).and_return(topic)
      end

      context 'with valid params' do

        before :each do
          topic.should_receive(:delete!).and_return(true)
          delete :destroy, :id => topic.slug
        end

        it 'redirect to back' do
          response.should redirect_to topics_path
        end

        it 'should have a notice message' do
          flash[:notice].should == I18n.t('topics.delete.success')
        end

      end

      context 'without valid params' do

        before :each do
          topic.should_receive(:delete!).and_return(false)
          delete :destroy, :id => topic.slug
        end

        it 'redirect to back' do
          response.should redirect_to topics_path
        end

        it 'should have a notice message' do
          flash[:alert].should == I18n.t('topics.delete.fail')
        end

      end
    end

    describe 'members' do
      describe 'PUT add_member' do

        context 'with valid params' do
          before :each do
            Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
            topic.should_receive(:first).and_return(topic)
            topic.should_receive(:add_member).and_return(true)
            put :add_member, :id => topic.slug, :nickname => member.nickname
          end

          it 'should be redirect' do
            response.should redirect_to topic_path(topic)
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
            Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
            topic.should_receive(:first).and_return(topic)
            topic.should_receive(:add_member).and_return(false)
            put :add_member, :id => topic.slug, :nickname => member.nickname
          end

          it 'should be redirect' do
            response.should redirect_to topic_path(topic)
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
            Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
            topic.should_receive(:first).and_return(topic)
            topic.should_receive(:rm_member!).with(member.nickname).and_return(true)
            put :rm_member, :id => topic.slug, :nickname => member.nickname
          end

          it 'should be redirect' do
            response.should redirect_to topic_path(topic)
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
            Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
            topic.should_receive(:first).and_return(topic)
            topic.should_receive(:rm_member!).with(member.nickname).and_return(false)
            put :rm_member, :id => topic.slug, :nickname => member.nickname
          end

          it 'should be redirect' do
            response.should redirect_to topic_path(topic)
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

  end

end
