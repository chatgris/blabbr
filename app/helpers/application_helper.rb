# encoding: utf-8
require 'digest/md5'

module ApplicationHelper
  def current_tz(date)
    date.in_time_zone(current_user.time_zone)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

end
