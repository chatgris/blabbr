# encoding: utf-8
def mock_member(options = {}, stubs = {})
  mock = mock_model(Member, stubs)
  mock.stub!(:id).and_return(Random.new().rand(0..100).to_i)
  mock.stub!(:nickname).and_return(Faker::Name.first_name)

  mock
end
