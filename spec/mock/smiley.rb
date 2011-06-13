# encoding: utf-8
def mock_smiley(options = {}, stubs={})
  mock = mock_model(Smiley, stubs)
  mock.stub!(:id).and_return(1)
  mock.stub!(:code).and_return('blabla')
  mock.stub!(:added_by).and_return('chatgris')
  mock.stub!(:image).and_return(SmileyUploader.new)
  mock.stub!(:image?).and_return(true)
  mock.stub!(:image_url).and_return('/user.avatar.jpg')
  mock.stub!(:image_cache).and_return('/user.avatar.jpg')
  mock.stub!(:to_json).and_return(mock.as_json)
  mock.stub!(:as_json).and_return({})
  mock
end
