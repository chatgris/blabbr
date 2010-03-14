require 'digest/md5'

module ApplicationHelper

  def title(page_title)
    content_for(:title) { "Blabber - #{page_title}" }
  end
  
  def format_text(text)
    smilies(RedCloth.new(text.to_s).to_html(:textile))
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def unread_posts(subscribers)
    subscribers.each do |s|
      return s.message if s.nickname == @current_user.nickname
    end
  end
  
  def available_i18n
    dirs = Dir.entries("#{Rails.root}/config/locales/")
    
    locales = []
    dirs.each do |dir|
      if File.extname(dir) == '.yml' && dir != '.' && dir != '..'
        locales << dir.gsub(File.extname(dir), '')
      end
    end
    locales
  end
  
  def gravatar_url(email,gravatar_options={})
    gravatar_options[:size] ||= nil 
    gravatar_options[:default] ||= nil
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << "gravatar_id=#{Digest::MD5.new.update(email)}" 
    grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
    grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
    grav_url
  end
  
  def smilies(text)
    dirs = Dir.entries("#{Rails.root}/public/images/smilies")

    dirs.each do |dir|
      unless dir == '.' || dir == '..'
        dir_name = dir.gsub(File.extname(dir), '')
        text.gsub!(/:#{dir_name}/, "<img src=\"/images/smilies/#{dir}\" alt=\"#{dir_name}\" />")
      end
    end
    text
  end


end
