module TopicsHelper
  def textilize(text)
    auto_link(RedCloth.new(text, @smilies).to_html(:textile, :refs_smiley)) unless text.blank?
  end

  def post_ratio(topic)
    topic.members.each do |member|
      return "#{member.posts_count}/#{topic.posts_count}" if member.nickname == current_user.nickname
    end
  end

  def attachments_ratio(topic)
    topic.members.each do |member|
      return "#{member.attachments_count}/#{topic.attachments_count}" if member.nickname == current_user.nickname
    end
  end

  def members_without_creator(topic)
    topic.members.select { |m| m.nickname != topic.creator }
  end
end
