require 'simple_validations/extensions/string'
require 'simple_validations/error'

module SimpleValidations
  module Validations
    class Validation
      using Extensions::String
      attr_reader :rule

      def initialize(rule = nil)
        @rule = rule
      end

      def type
        class_name.underscore.split('_')[0...-1].join('_').to_sym
      end

      def call(value, _subject = nil)
        if valid?(value)
          []
        else
          [Error.new(type, value: value, validation: self)]
        end
      end

      private

      def valid?(_value)
        fail NotImplementedError, 'Should be implemented by subclass'
      end

      def class_name
        self.class.to_s.split('::').last
      end
    end
  end
end
