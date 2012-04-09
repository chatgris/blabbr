# encoding: utf-8
module BlabbrCore
  # Main implementation of BlabbrCore behavior.
  #
  module Domain
    module Collection
      # Create a new instance of klass.
      #
      # @param [ BlabbrCore::Persistence::User ] current user
      #
      # @since 0.0.1
      #
      def initialize(user = nil)
        @current_user = user
      end

      # Return a collection from klass.
      #
      # @example
      #   BlabbrCore::klass.new(current_user).all
      #
      # @return [ Array ]
      #
      # @since 0.0.1
      #
      def all
        guard!
        collection
      end

      private

      def collection
        @collection ||= klass.all
      end

      def klass
        persistence_class = self.class.to_s.demodulize.sub('Collection', '').singularize
        "BlabbrCore::Persistence::#{persistence_class}".constantize
      end
    end
  end
end
