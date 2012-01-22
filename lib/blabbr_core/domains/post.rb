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
    def initialize(user, topic, id = nil)
      @topic = topic
      super(user, id)
    end

    private

    def resource(id = nil)
      @resource ||=
        id.present? ? @topic.posts.find(id) : klass.new
    end

    def resource_for_creation(params = {})
      if @resource_for_creation
        @resource_for_creation
      else
        @resource = klass.new(params)
        @resource.author = current_user
        @resource.topic = @topic
        @resource_for_creation = @resource
      end
    end

  end # Post
end # BlabbrCore
