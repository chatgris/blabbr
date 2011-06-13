# encoding: utf-8
def mock_post(options = {}, stubs = {})
  mock = mock_model(Post, stubs)
  mock.stub!(:id).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:creator_s).and_return(Faker::Name.name.parameterize)
  mock.stub!(:creator_n).and_return(Faker::Name.name)
  mock.stub!(:body).and_return(Faker::Lorem.paragraphs(2).to_s)
  mock.stub!(:created_at).and_return(Time.now)
  mock.stub!(:state).and_return('published')
  mock.stub!(:page).and_return(1)
  mock.stub!(:to_json).and_return(mock.as_json)
  mock.stub!(:as_json).and_return({})
  mock
end
