# encoding: utf-8
Factory.define :user do |u|
  u.nickname                  "One user"
  u.email                     "mail@email.com"
  u.locale                    "fr"
  u.password                  "password"
  u.password_confirmation     "password"
  u.posts_count               12
end

Factory.define :invited, :class => "user" do |u|
  u.nickname                  "Invited member"
  u.email                     "newmail@email.com"
  u.locale                    "fr"
  u.password                  "password"
  u.password_confirmation     "password"
  u.posts_count               0
end

Factory.define :creator, :class => "user" do |u|
  u.nickname                  "creator"
  u.email                     "email@email.com"
  u.locale                    "fr"
  u.password                  "password"
  u.password_confirmation     "password"
  u.posts_count               12
end


Factory.define :post do |p|
  p.creator                      Factory.build(:creator)
  p.body                      "Some content"
end

Factory.define :topic do |t|
  t.title                     "One topic"
  t.creator                   "creator"
  t.user                      Factory.build(:creator)
  t.after_build do |tp|
    tp.posts.push(Factory.build(:post))
  end
end

Factory.define :member do |s|
  s.nickname                  "Member"
end

Factory.define:smiley do |s|
  s.code                      "doc"
  s.added_by                  "One user"
  s.height                    20
  s.width                     20
  s.image                     File.open(Rails.root.join("image.jpg"))
end
