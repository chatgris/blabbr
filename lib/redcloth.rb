class RedCloth::TextileDoc
  def glyphs_smilies(text)
    dirs = Dir.entries("#{RAILS_ROOT}/public/images/smilies")

    dirs.each do |dir|
      unless dir == '.' || dir == '..'
        dir_name = dir.gsub(File.extname(dir), '')
        text.gsub!(/:#{dir_name}/, "<img src=\"/images/smilies/#{dir}\" alt=\"#{dir_name}\" />")
      end
    end
  end
end
