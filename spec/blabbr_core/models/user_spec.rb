# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::User do
  describe 'Fields' do
    it { should have_fields(:email, :nickname) }
  end

  describe 'Relations' do
    it { should have_many(:topics).with_foreign_key(:user_id) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:nickname) }
    it { should validate_length_of(:nickname).within(8..42) }
    it { should validate_uniqueness_of(:nickname) }
  end
end
