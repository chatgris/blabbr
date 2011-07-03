module LinkHelper

  def link_to_unread(topic)
    topic.members.each do |m|
      if m.nickname == current_user.nickname
        if m.unread == 0
          return link_to m.unread, page_topic_path(topic.slug, :anchor => "new_post", :page => (topic.posts_count.to_f / PER_PAGE.to_f).ceil)
        else
          return link_to m.unread, page_topic_path(topic.slug, :anchor => m.post_id, :page => m.page), :class => "new"
        end
      end
    end
  end

  def link_to_avatar(user)
    slug = user.respond_to?(:slug) ? user.slug : user
    link_to image_tag("/uploads/avatars/#{slug}.png"), user_path(user)
  end

  def link_to_avatar_thumb(user)
    slug = user.respond_to?(:slug) ? user.slug : user
    link_to image_tag("/uploads/avatars/thumb_#{slug}.png?#{user.updated_at.to_i.to_s}"), user_path(user)
  end

  def link_to_edit_post(post, topic)
    link_to t('posts.edit'), edit_topic_post_path(topic.slug, post.id), :class => "edit", :remote => true, :message => post.id if post.creator_n == current_user.nickname
  end

end
