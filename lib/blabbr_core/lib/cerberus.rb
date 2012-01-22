# encoding: utf-8
module BlabbrCore
  # This module checks current user abilities againts a resource
  #
  module Cerberus
    class Error < StandardError; end

    extend ::ActiveSupport::Concern

    included do
      attr_reader :current_user
    end

    module InstanceMethods
      protected

      # Check current abilities.
      #
      # @return [ Boolean ]
      #
      # @since 0.0.1
      #
      def guard
        BlabbrCore::Cerberus::Ability.new(current_user, method_caller, self.class, @resource).valid?
      end

      # Raise an error if current_user is not authorized
      #
      # @return [ BlabbrCore::Cerberus::Error ]
      #
      # @since 0.0.1
      #
      def guard!
        raise Error, 'Not authorized' unless guard
      end

      private

      # Guess what method call guard
      #
      # @return [ String ]
      #
      def method_caller
        @method_caller ||= caller[2][/`([^']*)'/, 1]
      end
    end # InstanceMethods
  end # Cerberus
end # BlabbrCore
