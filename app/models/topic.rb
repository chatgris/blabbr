class Topic
  include MongoMapper::Document
  
  key :creator, String
  key :title, String
  key :permalink, String
  
  timestamps!
  
  before_validation_on_create :set_permalink
  
  protected
  
  def set_permalink
    self.permalink = title.parameterize.to_s
  end
  
  def self.new_by_params(params, user)
    topic = Topic.new(:title => params[:title],
                      :creator => user.nickname)
  end

end

