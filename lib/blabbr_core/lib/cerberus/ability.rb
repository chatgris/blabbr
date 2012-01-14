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
      def valid?
        if @user
          if klass == User
            if method == :update
              resource == user
            elsif method == :create
              false
            else
              true
            end
          end
        else
          false
        end
      end
    end # Ability
  end # Cerberus
end # BlabbrCore
