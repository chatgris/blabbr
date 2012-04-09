# encoding: utf-8
module BlabbrCore
  # BlabbrCore collection for Topic.
  #
  class TopicsCollection
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain::Collection

    private

    def collection
      @collection ||= current_user.admin? ? super :
        BlabbrCore::Persistence::Topic.with_member(current_user).all
    end
  end # TopicsCollection
end # BlabbrCore
