# encoding: utf-8
module BlabbrCore
  # BlabbrCore collection for Topic.
  #
  class PostsCollection
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain::Collection

    # Create a new instance of PostsCollection.
    #
    # @param [ Persistence::User ]  current_user.
    # @param [ Persistence::Topic ] topic.
    #
    # @since 0.0.1
    #
    def initialize(user = nil, topic)
      super(user)
      @topic = topic
    end

    private

    def collection
      @collection ||= @topic.posts.all
    end
  end # PostsCollection
end # BlabbrCore
