require 'spec_helper'

describe Post do
  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:nickname) }
  end
end
