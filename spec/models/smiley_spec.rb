require 'spec_helper'

describe Smiley do
  it { Smiley.fields.keys.should be_include('added_by')}
  it { Smiley.fields['added_by'].type.should == String}

  it { Smiley.fields.keys.should be_include('code')}
  it { Smiley.fields['code'].type.should == String}
end
