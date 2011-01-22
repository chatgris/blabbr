Fabricator(:user) do
  nickname     "One user"
  email        "mail@email.com"
  locale       "fr"
  password     "password"
  password_confirmation     "password"
  posts_count  12
end

Fabricator(:invited, :from => "user") do
  nickname     "Invited member"
  email        "newmail@email.com"
  locale       "fr"
  password     "password"
  password_confirmation "password"
  posts_count  0
end

Fabricator(:creator, :from => "user") do
  nickname     "creator"
  email        "email@email.com"
  locale       "fr"
  password     "password"
  password_confirmation "password"
  posts_count  12
end

Fabricator(:topic) do |t|
  title       "One topic"
  creator     "creator"
  user        Fabricate(:creator)
  post        "Some content"
end

Fabricator(:post) do
  body    "Some content"
end

Fabricator(:member) do
  nickname "Member"
end

Fabricator(:smiley) do
  code     "doc"
  added_by "One user"
  image    File.open(Rails.root.join("image.jpg"))
end
