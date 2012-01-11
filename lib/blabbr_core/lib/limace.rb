# encoding: utf-8
module BlabbrCore
  module Limace
    extend ::ActiveSupport::Concern

    included do
      field :limace, type: String
      scope :by_limace, lambda {|limace| where(limace: limace)}
      after_validation :set_limace
    end

    module ClassMethods
      attr_accessor :limace_field

      def limace(field)
        self.limace_field = field
      end

    end

    module InstanceMethods
      private

      def set_limace
        content = self.send(self.class.limace_field)
        self.limace = content.parameterize.blank? ? content : content.parameterize
      end
    end
  end
end
