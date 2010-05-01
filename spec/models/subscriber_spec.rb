require 'spec_helper'

describe Subscriber do
  describe "validations" do
    it { should validate_presence_of(:nickname) }
  end
end
