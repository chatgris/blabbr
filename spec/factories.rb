  Factory.define :topic do |t|
    t.title       "One topic"
    t.permalink   "one-topic"
    t.creator     "chatgris"
    t.post        "Some content"
    t.posts_count 0
  end

  Factory.define :user do |u|
    u.nickname     "One user"
    u.email        "mail@email.com"
    u.permalink    "one-user"
    u.identity_url "http://myopenid.com"
    u.locale       "fr"
    u.posts_count  12
  end

  Factory.define :post do |p|
    p.nickname "One user"
    p.content  "Some content"
  end
