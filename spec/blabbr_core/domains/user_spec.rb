# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::User do
  let!(:user)         { Factory :user }
  let!(:current_user) { Factory :user }
  let(:admin)         { Factory :admin }

  context 'with a current_user' do
    let(:domain) {
      BlabbrCore::User.new(current_user, user.limace)
    }

    it 'should find a specific user' do
      BlabbrCore::User.new(current_user, user.limace).find.should eq user
    end

    it 'should be able to update itself' do
      BlabbrCore::User.new(current_user, current_user.limace).update(nickname: 'test user').should be_true
      current_user.reload.nickname.should eq 'test user'
    end

    it 'should be inactive by default' do
      domain.should be_inactive
    end

    it 'should not be able to active a user' do
      lambda {
        domain.activate
      }.should raise_error
      domain.should_not be_active
    end

    it 'should not be able to ban a user' do
      lambda {
        domain.ban
      }.should raise_error
      domain.should_not be_banned
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end

  context 'with an admin' do
    let(:domain) {
      BlabbrCore::User.new(admin, user.limace)
    }

    it 'should find a specific user' do
      domain.find.should eq user
    end

    it 'should be able to update other user' do
      BlabbrCore::User.new(admin, current_user.limace).update(nickname: 'test user').should be_true
      current_user.reload.nickname.should eq 'test user'
    end

    it 'should be inactive by default' do
      domain.should be_inactive
    end

    it 'should be able to active a user' do
      domain.activate
      domain.should be_active
    end

    it 'should be able to ban a user' do
      domain.ban
      domain.should be_banned
    end

    it 'should be able to create a user' do
      BlabbrCore::User.new(admin).create(nickname: 'test user', email: 'email@mail.com').should be_true
    end
  end

  context 'with a user' do
    let(:domain) {
      BlabbrCore::User.new(user, user.limace)
    }

    it 'should find a specific user' do
      BlabbrCore::User.new(user, user.limace).find.should eq user
    end

    it 'should be inactive by default' do
      domain.should be_inactive
    end

    it 'should not be able to active a user' do
      lambda {
        domain.activate
      }.should raise_error
      domain.should_not be_active
    end

    it 'should not be able to ban a user' do
      lambda {
        domain.ban
      }.should raise_error
      domain.should_not be_banned
    end

    it 'should not be able to update a other user' do
      lambda {
        BlabbrCore::User.new(user, current_user.limace).update(nickname: 'test user')
      }.should raise_error
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end

  context 'without a user' do
    let(:domain) {
      BlabbrCore::User.new(nil, user.limace)
    }

    it 'should find a specific user' do
      lambda {BlabbrCore::User.new.find(user.limace)}.should raise_error
    end

    it 'should be inactive by default' do
      domain.should be_inactive
    end

    it 'should not be able to active a user' do
      lambda {
        domain.activate
      }.should raise_error
      domain.should_not be_active
    end

    it 'should not be able to ban a user' do
      lambda {
        domain.ban
      }.should raise_error
      domain.should_not be_banned
    end

    it 'should not be able to create a user' do
      lambda {
        BlabbrCore::User.new(user).create(nickname: 'test user')
      }.should raise_error
    end
  end
end
