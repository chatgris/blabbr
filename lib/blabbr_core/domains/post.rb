# encoding: utf-8
module BlabbrCore
  # BlabbrCore domains for Post.
  #
  # TODO: create and update
  #
  class Post
    include BlabbrCore::Cerberus
    include BlabbrCore::Domain

    private

    def resource(id)
      Persistence::Post.find(id)
    end
  end # Post
end # BlabbrCore
