# encoding: utf-8
def mock_post(options = {}, stubs = {})
  mock = mock_model(Post, stubs)
  mock.stub!(:id).and_return(1)

  mock
end
