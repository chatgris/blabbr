module LinkHelper

  def link_to_unread(topic)
    topic.members.each do |m|
      if m.nickname == current_user.nickname
        if m.unread == 0
          return link_to m.unread, page_topic_path(topic.permalink, :anchor => "new_post", :page => (topic.posts_count / PER_PAGE + 1))
        else
          return link_to m.unread, page_topic_path(topic.permalink, :anchor => m.post_id, :page => m.page), :class => "new"
        end
      end
    end
  end

  def link_to_avatar(user)
    link_to image_tag(user.avatar.url || user.gravatar_url + "80"), user_path(user.permalink)
  end

  def link_to_avatar_thumb(user)
    link_to image_tag(user.avatar.thumb.url || user.gravatar_url + "25"), user_path(user.permalink)
  end

  def link_to_edit_post(post, topic)
    link_to t('posts.edit'), edit_topic_post_path(topic.permalink, post.id) if post.user_id == current_user.id
  end

end
