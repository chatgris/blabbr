require 'carrierwave/orm/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname,  :type => String
  field :permalink, :type => String
  field :email,  :type => String
  field :identity_url, :type => String
  field :posts_count, :type => Integer, :default => 0
  field :locale, :type => String, :default => 'fr'
  field :note, :type => String
  field :avatar, :type => String

  mount_uploader :avatar, AvatarUploader

  validates_uniqueness_of :nickname, :permalink, :email, :identity_url
  validates_presence_of :nickname, :permalink, :email, :identity_url
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_validate :set_permalink

  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  named_scope :by_nickname, lambda { |nickname| { :where => { :nickname => nickname}}}

  protected

  def set_permalink
    self.permalink = nickname.parameterize.to_s unless nickname.nil?
  end

end
