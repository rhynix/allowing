require 'simple_validations/validations/validation'

module SimpleValidations
  module Validations
    class ExclusionValidation < Validation
      private

      def valid?(value)
        !rule.include?(value)
      end
    end
  end
end
