# encoding: utf-8
FactoryGirl.define do
  factory :member, class: BlabbrCore::Member do
    unread_count    { rand(767) }
  end
end

