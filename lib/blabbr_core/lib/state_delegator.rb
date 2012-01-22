# encoding: utf-8
module BlabbrCore
  # Delegates call to persistence.
  #
  module StateDelegator

    # Delegate state to BlabbrCore::Persistence::Post.
    #
    # @example
    #   BlabbrCore::Post.new(current_user).one('my-user').state
    #
    # @return [ Symbol ]
    #
    # @since 0.0.1
    #
    def state
      resource.state
    end

    # Delegate state= to BlabbrCore::Persistence::Post.
    #
    # @example
    #   BlabbrCore::Post.new(current_user).one('my-user').state
    #
    # @return [ Symbol ]
    #
    # @since 0.0.1
    #
    def state=(arg)
      resource.state = arg
    end

    # Delegate save! to BlabbrCore::Persistence::Post.
    #
    # Was implemented for SimpleStates.
    #
    # @example
    #   BlabbrCore::Post.new(current_user).one('my-user').save!
    #
    # @return [ Symbol ]
    #
    # @since 0.0.1
    #
    def save!
      resource.save!
    end
  end
end
