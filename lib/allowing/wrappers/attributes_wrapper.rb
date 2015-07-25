require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class AttributesWrapper < Wrapper
      def call(value, subject = nil)
        rule.flat_map do |attribute|
          validate_attribute(attribute, value, subject)
        end
      end

      private

      def validate_attribute(attribute, value, subject)
        scoped_value  = scoped_value_for(attribute, value)
        errors        = validation.call(scoped_value, subject)

        scoped_errors_for(attribute, errors)
      end

      def scoped_value_for(attribute, value)
        return value if attribute.nil?

        value.send(attribute)
      end

      def scoped_errors_for(attribute, errors)
        errors.map { |error| error.scoped(attribute) }
      end
    end
  end
end
