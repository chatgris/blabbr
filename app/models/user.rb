require 'carrierwave/orm/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname
  field :permalink
  field :email
  field :identity_url
  field :posts_count, :type => Integer, :default => 0
  field :locale, :default => 'fr'
  field :note
  field :avatar
  field :gravatar_url
  field :attachments_count, :type => Integer, :defalut => 0

  embeds_many :attachments

  mount_uploader :avatar, AvatarUploader

  before_validate :set_permalink, :set_gravatar_url

  validates_uniqueness_of :nickname, :permalink, :email, :identity_url
  validates_presence_of :nickname, :permalink, :email, :identity_url
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :nickname, :maximum => 40

  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  named_scope :by_nickname, lambda { |nickname| { :where => { :nickname => nickname}}}

  protected

  def set_permalink
    self.permalink = nickname.parameterize.to_s unless nickname.nil?
  end

  def set_gravatar_url
    hash = Digest::MD5.hexdigest(email.downcase.strip)[0..31]
    self.gravatar_url = "http://www.gravatar.com/avatar/#{hash}.jpg?size="
  end

end
