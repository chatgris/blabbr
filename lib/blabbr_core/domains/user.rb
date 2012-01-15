# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for User.
  #
  class User
    include BlabbrCore::Cerberus

    # Create a new instance of User.
    #
    # @param [ BlabbrCore::Persistence::User ] current user
    #
    def initialize(user = nil)
      @current_user = user
    end

    # Return a collection from User.
    #
    # @example
    #   BlabbrCore::User.new(current_user).all
    #
    # @return [ Array ]
    #
    def all
      guard! :all
      collection
    end

    # Return a resource from User.
    #
    # @example
    #   BlabbrCore::User.new(current_user).find('my-user')
    #
    # @return [ BlabbrCore::Persistence::User ]
    #
    def find(limace)
      guard! :find, resource(limace)
      resource(limace)
    end

    # Update a user attributes.
    #
    # @example
    #   BlabbrCore::User.new(current_user).update(current_user, params)
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
    #   BlabbrCore::User.new(current_user).create(params)
    #
    # @return [ Boolean ]
    #
    def create(params)
      guard! :create
      resource_for_creation(params).save
    end

    private

    def resource_for_creation(params)
      @resource_for_creation ||= BlabbrCore::Persistence::User.new(params)
    end

    def resource(limace)
      @resource ||= BlabbrCore::Persistence::User.by_limace(limace).one
    end

    def collection
      @collection ||= BlabbrCore::Persistence::User.all
    end
  end # User
end # BlabbrCore
