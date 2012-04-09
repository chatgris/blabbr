# encoding: utf-8
module BlabbrCore
  # Main implementation of BlabbrCore behavior.
  #
  module Domain
    module Resource
      # Create a new instance of klass.
      #
      # @param [ BlabbrCore::Persistence::User ] current user
      # @param [ String ] resource's identifier
      #
      # @since 0.0.1
      #
      def initialize(user = nil, limace = nil)
        resource(limace)
        @current_user = user
      end

      # Return a resource from klass.
      #
      # @example
      #   BlabbrCore::klass.new(current_user).find('my-user')
      #
      # @return [ BlabbrCore::Persistence::klass ]
      #
      # @since 0.0.1
      #
      def find
        guard!
        resource
      end

      # Update a user attributes.
      #
      # @example
      #   BlabbrCore::klass.new(current_user).update(current_user, params)
      #
      # @return [ Boolean ]
      #
      # @since 0.0.1
      #
      def update(params)
        guard!
        resource.update_attributes(params)
      end

      # Create a new user.
      #
      # @example
      #   BlabbrCore::klass.new(current_user).create(params)
      #
      # @return [ Boolean ]
      #
      # @since 0.0.1
      #
      def create(params)
        resource_for_creation(params)
        guard!
        resource_for_creation.save
      end

      private

      def resource(limace = nil)
        @resource ||= klass.by_limace(limace).one || klass.new
      end

      def resource_for_creation(params = {})
        @resource_for_creation ||= klass.new(params)
      end

      def klass
        "BlabbrCore::Persistence::#{self.class.to_s.demodulize}".constantize
      end
    end
  end
end
