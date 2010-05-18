class Textilizer
  def initialize(text)
    @text = text
  end

  def to_html
    RedCloth.new(@text).to_html
  end

end
