module RedCloth::Formatters::HTML

 include RedCloth::Formatters::Base

 def after_transform(text)
   text.chomp!
   clean_html(text, ALLOWED_TAGS)
 end

 ALLOWED_TAGS = {
     'a' => ['href', 'title'],
     'img' => ['href', 'src', 'title'],
     'br' => [],
     'strong' => nil,
     'em' => nil,
     'sup' => nil,
     'sub' => nil,
     'ol' => ['start'],
     'ul' => nil,
     'li' => nil,
     'p' => nil,
     'blockquote' => ['cite'],
   }

end
