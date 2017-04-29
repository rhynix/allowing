require 'simple_validations/validations/validation'

module SimpleValidations
  module Validations
    class FormatValidation < Validation
      private

      def valid?(value)
        !value.nil? && value.to_s =~ rule
      end
    end
  end
end
