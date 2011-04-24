# encoding: utf-8
module Mongoid::Slug

  extend ActiveSupport::Concern

  included do
    field :slug, :type => String
    set_callback :create, :before, :set_slug
    named_scope :by_slug, lambda { |slug| { :where => { :slug => slug}}}
    delegate :slugged, :to => "self.class"
  end

  def set_slug
    self.slug = self.send(slugged).parameterize.to_s
  end

  def to_param
    slug
  end

  module ClassMethods
    attr_accessor :slugged

    def slug_field(slug_field)
      self.slugged = slug_field
    end

  end

end
