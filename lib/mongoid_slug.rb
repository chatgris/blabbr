# encoding: utf-8
module Mongoid
  module Slug
    extend ActiveSupport::Concern

    included do
      cattr_accessor :slug, :slugged
      named_scope :by_slug, lambda { |slug| { :where => { :slug => slug}}}
    end

    module ClassMethods

      def slug_field(slug_field)
        self.slugged = slug_field
        field :slug, :type => String
        before_create :set_slug
        index :slug
      end
    end

    def set_slug
      self.slug = self.send(slugged).parameterize.to_s
    end
  end
end
