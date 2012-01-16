# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Topic.
  #
  class Topic
    include BlabbrCore::Cerberus

    # Create a new instance of Topic.
    #
    # @param [ BlabbrCore::Persistence::Topic ] current user
    #
    def initialize(user = nil)
      @current_user = user
    end

    # Return a collection from Topic.
    #
    # @example
    #   BlabbrCore::Topic.new(current_user).all
    #
    # @return [ Array ]
    #
    def all
      guard! :all
      collection
    end

    # Return a resource from Topic.
    #
    # @example
    #   BlabbrCore::Topic.new(current_user).find('my-user')
    #
    # @return [ BlabbrCore::Persistence::Topic ]
    #
    def find(limace)
      guard! :find, resource(limace)
      resource(limace)
    end

    private

    def resource(limace)
      @resource ||= BlabbrCore::Persistence::Topic.by_limace(limace).one
    end

    def collection
      @collection ||=
        if current_user.admin?
          BlabbrCore::Persistence::Topic.all
        else
          BlabbrCore::Persistence::Topic.with_member(current_user).all
        end
    end
  end # Topic
end # BlabbrCore
