# encoding: utf-8
FactoryGirl.define do
  factory :user, class: BlabbrCore::User do
    nickname { Faker::Name.name }
    email    { Faker::Internet.email }
  end
end
