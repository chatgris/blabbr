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
      def initialize(user, method, klass, resource)
        @user = user
        @method = method
        @klass = klass
        @resource = resource
      end

      # Über and ugly basic rules for resource abilities check.
      #
      # @return [ Boolean ]
      #
      def valid?
        if @user
          if klass == User
            if method == :update
              return resource == user || user.admin?
            elsif method == :create
              return user.admin?
            else
              return true
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
            if user.admin?
              return true
            end
            if resource
              return resource.topic.members.where(user_id: user.id).exists?
            end
            return true
          end
        else
          false
        end
      end
    end # Ability
  end # Cerberus
end # BlabbrCore
