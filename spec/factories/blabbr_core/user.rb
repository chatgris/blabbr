# encoding: utf-8
FactoryGirl.define do
  factory :user, class: BlabbrCore::User do
    nickname 'nickname'
    email    'nickname@email.com'
  end
end
