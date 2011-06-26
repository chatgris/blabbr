# encoding: utf-8
def mock_user(options = {}, stubs = {})
  mock = mock_model(User, stubs)
  mock.stub!(:posts_count).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:id).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:nickname).and_return(Faker::Name.first_name)
  mock.stub!(:slug).and_return(mock.nickname.parameterize)
  mock.stub!(:time_zone).and_return(Time.zone)
  mock.stub!(:email).and_return(Faker::Internet.email)
  mock.stub(:audio).and_return(true)
  mock.stub!(:avatar?).and_return(true)
  mock.stub!(:avatar_url).and_return('/user.avatar.jpg')
  mock.stub!(:avatar_cache).and_return('/user.avatar.jpg')
  mock.stub!(:to_json).and_return(mock.as_json)
  mock.stub!(:as_json).and_return({})

  mock
end
