class String
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end

module RedCloth
  class TextileDoc
    def initialize( string, smilies, restrictions = [] )
      @smilies = smilies
      restrictions.each { |r| method("#{r}=").call( true ) }
      super(string)
    end
  end
end


module RedClothSmileyExtension
  def refs_smiley(text)
    if @smilies
      @smilies.each do |smiley|
        text.gsub!(":#{smiley.code}:", "!#{smiley.path}?#{smiley.ts}(#{smiley.code})!")
      end
    end
    text
  end
end

RedCloth.send(:include, RedClothSmileyExtension)

module RedCloth::Formatters::HTML

  include RedCloth::Formatters::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

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
