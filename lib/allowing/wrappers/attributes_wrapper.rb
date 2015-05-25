require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class AttributesWrapper < Wrapper
      def validate(value, subject, errors)
        rule.each do |attribute|
          validate_attribute(attribute, value, subject, errors)
        end
      end

      def validate_attribute(attribute, value, subject, errors)
        scoped_errors = []
        scoped_value  = scoped_value_for(attribute, value)

        validation.validate(scoped_value, subject, scoped_errors)

        scope_errors_for(attribute, scoped_errors)
        errors.push(*scoped_errors)
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
