require 'digest/md5'

module ApplicationHelper

  def title(page_title)
    content_for(:title) { "Blabber - #{page_title}" }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def unread_posts(members)
    members.each do |s|
      return s.unread if s.nickname == current_user.nickname
    end
  end

end
