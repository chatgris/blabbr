# encoding: utf-8
FactoryGirl.define do
  factory :topic, class: BlabbrCore::Persistence::Topic do
    title  'My brand new topic'
    author { Factory :user }
  end
end
