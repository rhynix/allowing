require 'allowing/validations/attribute_validation'
require 'allowing/helpers/scope_helpers'

module Allowing
  module Validations
    class WithValidation < AttributeValidation
      include Helpers::ScopeHelpers
      alias_method :validator, :rule

      def validate(subject, errors)
        with_scope(attribute, subject, errors) do |subject, errors|
          validator.new(subject).validate(subject, errors)
        end
      end
    end
  end
end
