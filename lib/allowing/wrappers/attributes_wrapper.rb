require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class AttributesWrapper < Wrapper
      def validate(value, subject = nil)
        rule.flat_map do |attribute|
          validate_attribute(attribute, value, subject)
        end
      end

      def validate_attribute(attribute, value, subject)
        scoped_value  = scoped_value_for(attribute, value)
        errors        = validation.validate(scoped_value, subject)

        scope_errors_for(attribute, errors)

        errors
      end

      def scoped_value_for(attribute, value)
        return value if attribute.nil?

        value.send(attribute)
      end

      def scope_errors_for(attribute, errors)
        errors.each { |error| error.unshift_scope(attribute) }
      end
    end
  end
end
