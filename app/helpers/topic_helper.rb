module TopicHelper
  def textilize(text)
    Textilizer.new(text).to_html unless text.blank?
  end

  def post_ratio(topic)
    topic.members.each do |member|
      return "#{member.posts_count}/#{topic.posts_count}" if member.nickname == current_user.nickname
    end
  end
end
