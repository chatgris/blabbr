# encoding: utf-8
FactoryGirl.define do
  factory :user, class: BlabbrCore::Persistence::User do
    nickname { Faker::Name.name }
    email    { Faker::Internet.email }
    password 'password'

    trait :admin do
      roles [:admin]
    end

    factory :admin,              :traits => [:admin]
  end
end
