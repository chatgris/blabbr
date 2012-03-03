# encoding: utf-8
module BlabbrCore
  class Ability < BlabbrCore::Cerberus::Ability
    def initialize(user, method, klass, resource)
      super
      can [TopicsCollection, UsersCollection, PostsCollection], :all
      if user.admin?
        can User,  [:update, :find, :create, :activate, :activate!, :ban, :ban!]
        can Topic, [:create, :update, :find, :all, :add_post]
        can Post,  [:update, :create, :find, :published, :published!, :unpublished, :unpublished!]
      else
        can User, [:update] do |u|
          u == user
        end
        can Topic, [:all, :create]
        can Topic, [:find, :add_post] do |topic|
          topic.members.where(user_id: user.id).exists? if topic
        end
        can Topic, [:find, :add_post, :update] do |topic|
          topic.author == user if topic
        end
        can User, [:find, :all]
        can Post, [:find, :create] do |post|
          post.topic.members.where(user_id: user.id).exists? if post
        end
        can Post, [:update, :create, :find, :published, :published!, :unpublished, :unpublished!] do |post|
          post.author == user
        end
      end
    end
  end # Ability
end # BlabbrCore
