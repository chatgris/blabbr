  Factory.define :topic do |t|
    t.title       "One topic"
    t.permalink   "one-topic"
    t.creator     "chatgris"
    t.post        "Some content"
  end

  Factory.define :user do |u|
    u.nickname     "One user"
    u.email        "mail@email.com"
    u.permalink    "one-user"
    u.identity_url "http://myopenid.com"
    u.locale       "fr"
    u.posts_count  12
  end

  Factory.define :chatgris, :class => "user" do |u|
    u.nickname     "chatgris"
    u.email        "email@email.com"
    u.permalink    "chatgris"
    u.identity_url "http://openid.net"
    u.locale       "fr"
    u.posts_count  0
  end

  Factory.define :post do |p|
    p.nickname "One user"
    p.content  "Some content"
  end

  Factory.define :member do |s|
    s.nickname "Member"
  end

  Factory.define:smiley do |s|
    s.code     "doc"
    s.added_by "One user"
  end
