module TopicHelper
  def textilize(text)
    Textilizer.new(text).to_html unless text.blank?
  end
end
