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
    # @return [ Array ]
    #
    def all
      guard!
      collection
    end

    # Return a resource from User.
    #
    # @return [ BlabbrCore::Persistence::User ]
    #
    def find(limace)
      guard!
      ressource(limace)
    end

    private

    def ressource(limace)
      @ressource ||= BlabbrCore::Persistence::User.by_limace(limace).one
    end

    def collection
      @collection ||= BlabbrCore::Persistence::User.all
    end
  end
end
