# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Topic.
  #
  # TODO: create and update
  #
  class Topic
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain::Resource

    # Add a new post to current topics.
    #
    # @param [ Hash ] post's attributes.
    #
    # @example
    #   BlabbrCore::Topic.new(current_user, 'my-topic').add_post(post_attributes)
    #
    # @return [ Boolean ]
    #
    # @since 0.0.1
    #
    def add_post(post_attributes)
      guard!
      BlabbrCore::Post.new(current_user, resource).create(post_attributes)
    end

    # Update a new post to current topics.
    #
    # @param [ Hash ] post's attributes.
    #
    # @example
    #   BlabbrCore::Topic.new(current_user, 'my-topic').update_post(1, post_attributes)
    #
    # @return [ Boolean ]
    #
    # @since 0.0.1
    #
    def update_post(id, post_attributes)
      guard!
      BlabbrCore::Post.new(current_user, resource, id).update(post_attributes)
    end
  end # Topic
end # BlabbrCore
