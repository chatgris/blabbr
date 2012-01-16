# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Topic.
  #
  # TODO: create and update
  #
  class Topic
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain

    private

    def collection
      @collection ||= current_user.admin? ? super :
        BlabbrCore::Persistence::Topic.with_member(current_user).all
    end
  end # Topic
end # BlabbrCore
