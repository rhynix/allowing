require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class InclusionValidation < AttributeValidation
      private

      def valid?(value)
        rule.include?(value)
      end
    end
  end
end
