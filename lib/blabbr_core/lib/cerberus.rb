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
      def guard
        current_user
      end

      # Raise an error if current_user is not authorized
      #
      # @return [ BlabbrCore::Cerberus::Error ]
      #
      def guard!
        raise Error, 'Not authorized' unless guard
      end
    end

  end
end
