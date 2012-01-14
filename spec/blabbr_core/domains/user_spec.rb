# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::User do
  let(:current_user) { Factory :user }
  let(:user)         { Factory :user }

  context 'with a current_user' do
    before do
      user
      current_user
    end

    it 'it should find all user' do
      BlabbrCore::User.new(current_user).all.to_a.should eq [user, current_user]
    end

    it 'should find a specific user' do
      BlabbrCore::User.new(current_user).find(user.limace).should eq user
    end

    it 'should be able to update itself' do
      BlabbrCore::User.new(current_user).update(current_user.limace, nickname: 'test user').should be_true
      current_user.reload.nickname.should eq 'test user'
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end

  context 'with a user' do
    before do
      user
      current_user
    end

    it 'it should find all user' do
      BlabbrCore::User.new(user).all.to_a.should eq [user, current_user]
    end

    it 'should find a specific user' do
      BlabbrCore::User.new(user).find(user.limace).should eq user
    end

    it 'should not be able to update a other user' do
      lambda {
        BlabbrCore::User.new(user).update(current_user.limace, nickname: 'test user')
      }.should raise_error
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end

  context 'without a user' do
    before do
      user
      current_user
    end

    it 'it should find all user' do
      lambda {BlabbrCore::User.new.all}.should raise_error
    end

    it 'should find a specific user' do
      lambda {BlabbrCore::User.new.find(user.limace)}.should raise_error
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end
end
