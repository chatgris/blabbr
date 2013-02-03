class Ability
  include CanCan::Ability

  def initialize(user)
    # Topic
    can :read, [Topic] do |topic|
      topic.members.map(&:nickname).include? user.nickname
    end
    can [:update, :destroy, :rm_member, :add_member], [Topic] do |topic|
      topic.creator == user.nickname
    end

    # Post
    can [:read, :create], [Post] do |post|
      post.topic.members.map(&:nickname).include? user.nickname
    end
    can [:update, :destroy], [Post] do |post|
      post.creator_n == user.nickname
    end

    # Creation
    can :create, [Topic, Smiley]

  end
end
