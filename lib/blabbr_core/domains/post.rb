# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Post.
  #
  # TODO: create and update
  #
  class Post
    include BlabbrCore::Cerberus
    include BlabbrCore::StateDelegator
    include BlabbrCore::Domain::Resource
    include SimpleStates

    # States set up.
    states :published, :unpublished
    self.initial_state = :published

    # Transitions
    event :published,   to: :published, before: :guard!
    event :unpublished, to: :unpublished, before: :guard!

    # Create a new instance of Post.
    #
    # @param [ Persistence::User ]  current_user.
    # @param [ Persistence::Topic ] topic.
    # @param [ String ] post's id.
    #
    # @since 0.0.1
    #
    def initialize(user = nil, topic, id)
      @topic = topic
      super(user, id)
    end

    private

    def resource(id = nil)
      @resource ||= @topic.posts.find(id)
    end
  end # Post
end # BlabbrCore
