# encoding: utf-8
def mock_user(options = {}, stubs = {})
  mock = mock_model(User, stubs)
  mock.stub!(:id).and_return(1)
  mock.stub(:nickname).and_return('chatgris')
  mock.stub!(:time_zone).and_return(Time.zone)
  mock.stub(:audio).and_return(true)

  mock
end
