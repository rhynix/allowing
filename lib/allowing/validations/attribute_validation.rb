require 'allowing/extensions/string'

module Allowing
  module Validations
    class AttributeValidation
      using Extensions::String
      attr_reader :rule, :attribute

      def initialize(rule, attribute)
        @rule      = rule
        @attribute = attribute
      end

      def type
        class_name.underscore.split('_')[0...-1].join('_').to_sym
      end

      def validate(subject, errors)
        value = value(subject)
        return if valid?(value)

        error = Error.new(
          type,
          value: value,
          scope: attribute,
          validation: self
        )
        errors << error
      end

      private

      def valid?(_value)
        fail NotImplementedError, 'Should be implemented by subclass'
      end

      def value(subject)
        subject.send(attribute)
      end

      def class_name
        self.class.to_s.split('::').last
      end
    end
  end
end
