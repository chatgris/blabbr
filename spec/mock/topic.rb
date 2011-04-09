# encoding: utf-8
def mock_topic(options = {}, stubs = {})
  mock = mock_model(Topic, stubs)
  mock.stub!(:id).and_return(1)
  mock.stub!(:title).and_return('Title')
  mock.stub!(:slug).and_return('title')

  mock
end
