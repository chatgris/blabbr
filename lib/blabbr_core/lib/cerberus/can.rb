# encoding: utf-8
module BlabbrCore
  # This module checks current user abilities againts a resource
  #
  module Cerberus
    module Can

      extend ::ActiveSupport::Concern

      included do
        attr_reader :cans
      end

      def can(klasses, methods, &block)
        Array(klasses).each do |klass|
          @cans[klass] ||= []
          Array(methods).each do |method|
            if block
              @cans[klass] << {method => block }
            else
              @cans[klass] << method
            end
          end
        end
      end
    end # Can
  end # Cerberus
end # BlabbrCore
