require 'allowing/extensions/string'
require 'allowing/error'

module Allowing
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

      def validate(value, _subject)
        return [] if valid?(value)

        [Error.new(type, value: value, validation: self)]
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
