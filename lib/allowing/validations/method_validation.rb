require 'allowing/validations/validation'

module Allowing
  module Validations
    class MethodValidation < Validation
      def validate(value, options)
        options[:validator].public_send(rule, value)
      end
    end
  end
end
