class Textilizer
  def initialize(text)
    @text = text
  end

  def to_html
    smilirize(RedCloth.new(@text).to_html)
  end

  def smilirize(text)
    Smiley.all.flatten.each do |smiley|
      text.gsub!(/:#{smiley.code}:/, "<img src=\"#{smiley.image.url}\" alt=\"#{smiley.code}\" />")
    end
    text
  end

end
