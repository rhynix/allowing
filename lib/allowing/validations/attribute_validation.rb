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
        errors << Error.new(type, attribute, self) unless valid?(value(subject))
      end

      private

      def valid?(value)
        raise NotImplementedError, 'Should be implemented by subclass'
      end

      def value(subject)
        subject.send(attribute)
      end

      def class_name
        class_name = self.class.to_s.split('::').last
      end
    end
  end
end
