# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Persistence::Topic do
  let(:topic) { Factory :topic }
  let(:user)  { Factory :user }

  describe 'Fields' do
    it { should have_fields(:title) }
  end

  describe 'Relations' do
    it { should belong_to(:author).of_type(BlabbrCore::Persistence::User) }
    it { should embed_many(:members) }
    it { should have_many(:posts) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_length_of(:title).within(8..42) }

    it 'should have a valid factory' do
      topic.should be_valid
    end
  end

  describe 'callbacks' do
    it 'should add author in members at creation' do
      topic.members.first.user.should eq topic.author
    end
  end

  describe 'scopes' do
    describe 'with_member' do
      it 'should have resutls' do
        BlabbrCore::Persistence::Topic.with_member(topic.author).to_a.
          should eq [topic]
      end

      it 'should not have resutls' do
        BlabbrCore::Persistence::Topic.with_member(user).to_a.
          should_not be_any
      end
    end
  end

  describe 'pagination' do
    let!(:topic1) { Factory :topic }
    let!(:topic2) { Factory :topic, title: 'Topic 2...' }

    it 'should be paginable' do
      described_class.page.should eq [topic1, topic2]
    end
  end

end
