module LinkHelper

  def link_to_unread(topic)
    topic.members.each do |m|
      if m.nickname == current_user.nickname
        if m.unread == 0
          return link_to m.unread, topic_path(topic.permalink, :anchor => "addComment", :page => (topic.posts_count / PER_PAGE + 1))
        else
          return link_to m.unread, topic_path(topic.permalink, :anchor => m.post_id, :page => m.page)
        end
      end
    end
  end

  def link_to_avatar(user)
    link_to image_tag(user.avatar.url || user.gravatar_url), user_path(user.permalink)
  end

end
