# encoding: utf-8
require 'carrierwave/orm/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Rails.application.routes.url_helpers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :nickname, :type  => String
  field :email, :type  => String
  field :posts_count, :type => Integer, :default => 0
  field :locale, :default => 'fr', :type  => String
  field :note, :type  => String
  field :time_zone, :type  => String, :default => "UTC"
  field :audio, :type => Boolean, :default => true
  field :attachments_count, :type => Integer, :default => 0

  mount_uploader :avatar, ::AvatarUploader
  embeds_many :attachments

  slug_field :nickname

  index :nickname

  attr_accessible :nickname, :email, :password, :password_confirmation, :locale, :note, :time_zone, :avatar, :audio

  validates :nickname, :presence => true, :uniqueness => true, :length => { :maximum => 40 }
  validates :email, :presence => true, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

  scope :by_nickname, ->(nickname) { where(:nickname => nickname)}

  def as_json(options={})
    options ||= {} #wtf
    super({:only => [:nickname, :posts_count, :audio, :timezone, :slug],
          :methods => [:avatar_path, :path, :tz]}.merge(options))
  end

  protected

  def avatar_path
    "#{self.avatar.url}?#{self.updated_at.to_i.to_s}"
  end

  def path
    user_path(self)
  end

  # Formatting tz for crappy js
  def tz
    ActiveSupport::TimeZone.new(self.time_zone).utc_offset / 60
  end

end
