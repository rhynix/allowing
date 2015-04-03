require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class ExclusionValidation < AttributeValidation
      private

      def valid?(value)
        !rule.include?(value)
      end
    end
  end
end
