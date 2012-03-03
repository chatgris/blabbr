# encoding: utf-8
module BlabbrCore
  module Cerberus
    class Ability
      include BlabbrCore::Cerberus::Can
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
        @cans = {}
      end

      # Über ugly basic rules for resource abilities check.
      #
      # @return [ Boolean ]
      #
      # @since 0.0.1
      #
      def valid?
        if cans[klass]
          cans[klass].each do |ary|
            return true if ary == method
            if ary.is_a?(Hash) && ary[method].present?
              return ary[method].call resource
            end
          end
          return false
        end
      end
    end # Ability
  end # Cerberus
end # BlabbrCore
