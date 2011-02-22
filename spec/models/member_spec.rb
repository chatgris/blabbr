require 'spec_helper'

describe Member do

  describe 'relation' do
    it {should be_embedded_in(:topic)}
  end

  describe 'fields' do
    it { should have_fields(:nickname, :post_id).of_type(String) }
    it { should have_fields(:page).of_type(Integer).with_default_value_of(1)}
    it { should have_fields(:unread).of_type(Integer).with_default_value_of(0)}
    it { should have_fields(:posts_count).of_type(Integer).with_default_value_of(0)}
    it { should have_fields(:attachments_count).of_type(Integer).with_default_value_of(0)}
  end

  describe 'validations' do
    it { should validate_presence_of(:nickname) }
    it { should validate_uniqueness_of(:nickname) }
  end

end
