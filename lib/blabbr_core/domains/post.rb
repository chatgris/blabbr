# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Post.
  #
  # TODO: create and update
  #
  class Post
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain

    # Create a new instance of Post.
    #
    # @param [ Persistence::User ]  current_user.
    # @param [ Persistence::Topic ] topic.
    #
    def initialize(user = nil, topic)
      @topic = topic
      super(user)
    end

    private

    def collection
      @collection ||= @topic.posts.all
    end

    def resource(id)
      @topic.posts.find(id)
    end
  end # Post
end # BlabbrCore
