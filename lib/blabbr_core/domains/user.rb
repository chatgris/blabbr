# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for User.
  #
  class User
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain::Resource
    include BlabbrCore::StateDelegator
    include SimpleStates

    # States set up.
    states :active, :inactive, :banned
    self.initial_state = :inactive

    # Transitions
    event :activate,   to: :active, before: :guard_activate!
    event :ban,        to: :banned, before: :guard_ban!

    def authenticate(nickname, password)
      klass.where(nickname: nickname).one.try(:authenticate, password)
    end

    private

    def guard_activate!
      guard! :activate
    end

    def guard_ban!
      guard! :ban
    end
  end # User
end # BlabbrCore
