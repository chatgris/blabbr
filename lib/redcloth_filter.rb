class Textilize
  include Rinku

  def initialize(text)
    @smilies = JSON.parse(Rails.cache.read('smilies_list')) || []
    @text = smilize(text)
  end

  def smilize(text)
    @smilies.inject(text) do |text, smiley|
      text.gsub(":#{smiley.code}:", "!#{smiley.path}?#{smiley.ts}(#{smiley.code})!")
    end
  end

  def to_html
    auto_link(RedCloth.new(@text).to_html(:textile))
  end
end

module RedCloth::Formatters::HTML

  include RedCloth::Formatters::Base

  def bq_close(opts)
    cite = opts[:cite] ? "<cite>#{ escape_attribute opts[:cite] }</cite>" : ''
    "#{cite}</blockquote>"
  end

  def before_transform(text)
    clean_html(text, ALLOWED_TAGS)
  end

  ALLOWED_TAGS = {
    'a' => ['href', 'title'],
    'img' => ['src', 'title', 'alt'],
    'br' => [],
    'strong' => nil,
    'em' => nil,
    'sup' => nil,
    'sub' => nil,
    'ol' => ['start'],
    'ul' => nil,
    'li' => nil,
    'p' => nil,
    'cite' => nil,
    'blockquote' => ['cite'],
    'qq' => ['cite'],
  }

end
