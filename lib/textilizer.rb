class Textilizer
  def initialize(text, smilies)
    @text, @smilies = text, smilies
  end

  def to_html
    smilirize(RedCloth.new(@text).to_html)
  end

  def smilirize(text)
    @smilies.each do |smiley|
      text.gsub!(/:#{smiley.code}:/, "<img src=\"#{smiley.image.url}?#{smiley.updated_at.to_i.to_s}\" alt=\"#{smiley.code}\" />")
    end
    text
  end

end
