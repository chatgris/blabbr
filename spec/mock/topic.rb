# encoding: utf-8
def mock_topic(options = {}, stubs = {})
  mock = mock_model(Topic, stubs)
  mock.stub!(:id).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:title).and_return(Faker::Lorem.sentence(18))
  mock.stub!(:slug).and_return(mock.title.parameterize)
  mock.stub!(:posts_count).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:creator).and_return(Faker::Name.first_name)
  mock.stub!(:last_user).and_return(Faker::Name.first_name)
  mock.stub!(:members).and_return([mock_member(nil, {:nickname => mock.creator})])
  mock.stub!(:posted_at).and_return(Time.now)

  mock
end
