require 'spec_helper'

describe PostsController do

  let(:topic)    {mock_topic}
  let(:topics)   {[mock_topic]}
  let(:one_post) {mock_post}
  let(:posts)    {[mock_post]}
  let(:user)     {mock_user}
  let(:member)   {mock_user}

  context "is a creator" do
    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      Topic.should_receive(:by_slug).and_return(topic)
      topic.should_receive(:by_subscribed_topic).with(user.nickname).and_return(topic)
      topic.should_receive(:first).and_return(topic)
    end

    describe 'GET edit' do
      before :each do
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:for_creator).and_return(posts)
        posts.should_receive(:find).with(one_post.id).and_return(one_post)
        get :edit, :topic_id => topic.slug, :id => one_post.id, :format => :json
      end

      it 'should assigns topic' do
        assigns(:topic).should == topic
      end

      it 'should assigns post' do
        assigns(:post).should == one_post
      end

    end

    describe 'PUT update' do
      before :each do
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:for_creator).and_return(posts)
        posts.should_receive(:find).with(one_post.id).and_return(one_post)
      end

      context 'with valid params' do
        before :each do
          one_post.should_receive(:update_attributes).with({'updated' => 'post'}).and_return(true)
          put :update, :topic_id => topic.id, :id => one_post.id, :post => {'updated' => 'post'}, :format => :json
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should assigns post' do
          assigns(:post).should == one_post
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('posts.update.success')
        end
      end

      context 'without valid params' do
        before :each do
          one_post.should_receive(:update_attributes).with({'updated' => 'post'}).and_return(false)
          put :update, :topic_id => topic.id, :id => one_post.id, :post => {'updated' => 'post'}, :format => :json
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should assigns post' do
          assigns(:post).should == one_post
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('posts.update.fail')
        end
      end

    end

    describe 'DELETE destroy' do
      before :each do
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:for_creator).and_return(posts)
        posts.should_receive(:find).with(one_post.id).and_return(one_post)
      end

      context 'with valid params' do
        before :each do
          one_post.should_receive(:delete!).and_return(true)
          delete :destroy, :topic_id => topic.id, :id => one_post.id, :format => :json
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should assigns post' do
          assigns(:post).should == one_post
        end

        it 'should have a flash message' do
          flash[:notice].should == I18n.t('posts.destroy.success')
        end
      end

      context 'without valid params' do
        before :each do
          one_post.should_receive(:delete!).and_return(false)
          delete :destroy, :topic_id => topic.slug, :id => one_post.id, :format => :json
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should assigns post' do
          assigns(:post).should == one_post
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('posts.destroy.fail')
        end
      end

    end

  end

  context "is a member" do

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(member)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    context 'doing public action' do

      before :each do
        Topic.should_receive(:by_slug).with(topic.slug).and_return(topic)
        topic.should_receive(:by_subscribed_topic).with(member.nickname).and_return(topic)
        topic.should_receive(:first).and_return(topic)
      end

      describe 'GET show' do
        before :each do
          topic.should_receive(:posts).and_return(posts)
          posts.should_receive(:find).with(one_post.id).and_return(one_post)
          topic.should_receive(:reset_unread)
          get :show, :topic_id => topic.slug, :id => one_post.id, :format => :json
        end

        it 'should be success' do
          response.should be_success
        end

        it 'should assigns topic' do
          assigns(:topic).should == topic
        end

        it 'should assigns post' do
          assigns(:post).should == one_post
        end
      end

      describe 'POST create' do
        before :each do
          Post.should_receive(:new).with({'new' => 'post'}).and_return(one_post)
          one_post.should_receive(:creator=).and_return(:user)
          one_post.should_receive(:topic=).and_return(:topic)
        end

        context 'with valid params' do
          before :each do
            one_post.should_receive(:save).and_return(true)
            post :create, :topic_id => topic.slug, :post => {'new' => 'post'}, :format => :json
          end

          it 'should assigns topic' do
            assigns(:topic).should == topic
          end

          it 'should assigns post' do
            assigns(:post).should == one_post
          end

          it 'should have a flash message' do
            flash[:notice].should == I18n.t('posts.create.success')
          end
        end

        context 'withiout valid params' do
          before :each do
            one_post.should_receive(:save).and_return(false)
            post :create, :topic_id => topic.slug, :post => {'new' => 'post'}, :format => :json
          end

          it 'should assigns topic' do
            assigns(:topic).should == topic
          end

          it 'should assigns post' do
            assigns(:post).should == one_post
          end

          it 'should have a flash message' do
            flash[:alert].should == I18n.t('posts.create.fail')
          end
        end
      end
    end

    context 'non public action' do
      before :each do
        controller.stub!(:logged_in?).and_return(true)
        controller.stub!(:current_user).and_return(member)
        request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
        Topic.should_receive(:by_slug).and_return(topic)
        topic.should_receive(:by_subscribed_topic).with(member.nickname).and_return(topic)
        topic.should_receive(:first).and_return(topic)
        topic.should_receive(:posts).and_return(posts)
        posts.should_receive(:for_creator).and_return(posts)
        posts.should_receive(:find).with(one_post.id).and_return(nil)
      end

      describe 'GET edit' do
        before :each do
          get :edit, :topic_id => topic.id, :id => one_post.id, :format => :json
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('posts.not_auth')
        end

      end

      describe 'PUT update' do

        before :each do
          one_post.should_not_receive(:update_attributes)
          put :update, :topic_id => topic.id, :id => one_post.id, :post => {'updated' => 'post'}, :format => :json
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('posts.not_auth')
        end

      end

      describe 'DELETE destroy' do
        before :each do
          one_post.should_not_receive(:delete!)
          delete :destroy, :topic_id => topic.id, :id => one_post.id, :format => :json
        end

        it 'should have a flash message' do
          flash[:alert].should == I18n.t('posts.not_auth')
        end

      end
    end

  end

end
