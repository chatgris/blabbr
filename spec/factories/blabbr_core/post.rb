# encoding: utf-8
FactoryGirl.define do
  factory :post, class: BlabbrCore::Post do
    body  'My brand new post'
    author { Factory :user }
    topic  { Factory :topic }
  end
end
