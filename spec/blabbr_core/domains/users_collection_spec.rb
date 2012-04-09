# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::UsersCollection do
  let!(:user)         { Factory :user }
  let!(:current_user) { Factory :user }
  let(:admin)         { Factory :admin }

  context 'with a current_user' do
    it 'it should find all user' do
      BlabbrCore::UsersCollection.new(current_user).all.to_a.should eq [user, current_user]
    end
  end

  context 'with an admin' do
    it 'it should find all user' do
      BlabbrCore::UsersCollection.new(admin).all.to_a.should eq [user, current_user, admin]
    end
  end

  context 'with a user' do
    it 'it should find all user' do
      BlabbrCore::UsersCollection.new(user).all.to_a.should eq [user, current_user]
    end
  end

  context 'without a user' do
    it 'it should find all user' do
      lambda {BlabbrCore::UsersCollection.new.all}.should raise_error
    end
  end
end
