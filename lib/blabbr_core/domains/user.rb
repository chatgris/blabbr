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
    event :activate,   to: :active, before: :guard!
    event :ban,        to: :banned, before: :guard!
  end # User
end # BlabbrCore
