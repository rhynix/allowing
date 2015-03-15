require 'allowing/extensions/string'

module Allowing
  module Wrappers
    class Wrapper
      using Extensions::String

      attr_reader :rule, :validation

      def initialize(rule, validation)
        @rule       = rule
        @validation = validation
      end

      def self.type
        class_name.underscore.split('_')[0...-1].join('_').to_sym
      end

      def self.inherited(base)
        wrappers[base.type] = base
      end

      def self.wrappers
        @wrappers ||= {}
      end

      private

      def self.class_name
        class_name = to_s.split('::').last
      end
    end
  end
end
