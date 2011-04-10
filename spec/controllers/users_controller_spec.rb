require 'spec_helper'

describe UsersController do

  let(:user) {mock_user}

  context 'whitout logged user' do

    describe 'POST create' do

      before :each do
        User.should_receive(:new).with({'new' => 'user'}).and_return(user)
      end

      context 'with valid params' do

        before :each do
          user.should_receive(:save).and_return(true)
          post :create, :user => {'new' => 'user'}
        end

        it 'should assign user' do
          assigns(:user).should == user
        end

        it 'should be redirected' do
          response.should redirect_to('/')
        end

        it 'should have a notice' do
          flash[:notice].should == I18n.t('users.create.success')
        end
      end

      context 'without valid params' do

        before :each do
          user.should_receive(:save).and_return(false)
          post :create, :user => {'new' => 'user'}
        end

        it 'should assign user' do
          assigns(:user).should == user
        end

        it 'should be redirected' do
          response.should redirect_to('/')
        end

        it 'should have a notice' do
          flash[:alert].should == I18n.t('users.create.fail')
        end
      end
    end
  end

  context 'with a logged user' do
    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    describe 'GET show' do
      before :each do
        User.should_receive(:by_slug).with(user.slug).and_return(user)
        user.should_receive(:first).and_return(user)
        get :show, :id => user.slug
      end

      it 'should be success' do
        response.should be_success
      end

      it 'should assign user' do
        assigns(:user).should == user
      end
    end

    context 'when user is current_user' do
      describe 'GET edit' do
        before :each do
          get :edit
        end

        it 'should assigns user' do
          assigns(:user).should == user
        end

        it 'should be success' do
          response.should be_success
        end
      end

      describe 'PUT update' do
        context 'with valid params' do
          before :each do
            user.should_receive(:update_attributes).with({'updated' => 'user'}).and_return(true)
            put :update, :id => user.slug, :user => {'updated' => 'user'}
          end

          it 'should assigns user' do
            assigns(:user).should == user
          end

          it 'should be redirect_to' do
            response.should redirect_to(user_path(user.slug))
          end

          it 'should have a notice' do
            flash[:notice].should == I18n.t('users.update.success')
          end
        end

        context 'without valid params' do
          before :each do
            user.should_receive(:update_attributes).with({'updated' => 'user'}).and_return(false)
            put :update, :id => user.slug, :user => {'updated' => 'user'}
          end

          it 'should assigns user' do
            assigns(:user).should == user
          end

          it 'should be redirect_to' do
            response.should redirect_to(user_path(user.slug))
          end

          it 'should have a notice' do
            flash[:alert].should == I18n.t('users.update.fail')
          end
        end
      end
    end

  end

end
