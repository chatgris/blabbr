module TopicsHelper
  def textilize(text)
    RedCloth.new(text, @smilies).to_html(:textile, :refs_smiley) unless text.blank?
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
    members = []
    topic.members.each do |member|
      next if member.nickname == topic.creator
      members << member.nickname
    end
    members
  end

end
