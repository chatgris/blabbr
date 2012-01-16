# encoding: utf-8
module BlabbrCore
  # Main implementation of BlabbrCore behavior.
  #
  module Domain
    # Create a new instance of klass.
    #
    # @param [ BlabbrCore::Persistence::klass ] current user
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
    def all
      guard! :all
      collection
    end

    # Return a resource from klass.
    #
    # @example
    #   BlabbrCore::klass.new(current_user).find('my-user')
    #
    # @return [ BlabbrCore::Persistence::klass ]
    #
    def find(limace)
      guard! :find, resource(limace)
      resource(limace)
    end

    # Update a user attributes.
    #
    # @example
    #   BlabbrCore::klass.new(current_user).update(current_user, params)
    #
    # @return [ Boolean ]
    #
    def update(limace, params)
      guard! :update, resource(limace)
      resource(limace).update_attributes(params)
    end

    # Create a new user.
    #
    # @example
    #   BlabbrCore::klass.new(current_user).create(params)
    #
    # @return [ Boolean ]
    #
    def create(params)
      guard! :create
      resource_for_creation(params).save
    end

    private

    def resource(limace)
      klass.by_limace(limace).one
    end

    def resource_for_creation(params)
      @resource_for_creation ||= klass.new(params)
    end

    def collection
      @collection ||= klass.all
    end

    def klass
      "BlabbrCore::Persistence::#{self.class.to_s.demodulize}".constantize
    end

  end
end
