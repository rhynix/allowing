require 'allowing/validations/validation'

module Allowing
  module Validations
    class ExclusionValidation < Validation
      private

      def valid?(value)
        !rule.include?(value)
      end
    end
  end
end
