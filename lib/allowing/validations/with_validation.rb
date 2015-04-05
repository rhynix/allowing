require 'allowing/validations/attribute_validation'
require 'allowing/helpers/scope_helpers'

module Allowing
  module Validations
    class WithValidation < AttributeValidation
      include Helpers::ScopeHelpers
      alias_method :validator, :rule

      def validate(subject, errors)
        with_scope(attribute, subject, errors) do |attr_subject, scoped_errors|
          validator.new(attr_subject).validate(scoped_errors)
        end
      end
    end
  end
end
