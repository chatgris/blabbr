# encoding: utf-8
module BlabbrCore
  module Cerberus
    class Ability
      attr_reader :user, :resource, :klass, :method

      # New ability object.
      #
      # @param [ BlabbrCore::User ] user performing the action
      # @param [ Symbol ] method performed by user
      # @param [ Class ]
      # @param [ Object ] object on which method is performed
      #
      # @since 0.0.1
      #
      def initialize(user, method, klass, resource)
        @user = user
        @method = method.to_sym
        @klass = klass
        @resource = resource
      end

      # Über ugly basic rules for resource abilities check.
      #
      # @return [ Boolean ]
      #
      # @since 0.0.1
      #
      def valid?
        if @user
          if klass == User
            if method == :update
              return resource == user || user.admin?
            elsif method == :find
              return true
            else
              return user.admin?
            end
          end
          if klass == Topic
            if user.admin?
              return true
            end
            if resource
              return resource.members.where(user_id: user.id).exists?
            end
            return true
          end
          if klass == Post
            if user.admin? || resource.author == user
              return true
            end
            if method.to_sym == :find && resource
              return resource.topic.members.where(user_id: user.id).exists?
            end
            return false
          end
          if [TopicsCollection, UsersCollection, PostsCollection].include?(klass)
            return true
          end
        else
          false
        end
      end
    end # Ability
  end # Cerberus
end # BlabbrCore
