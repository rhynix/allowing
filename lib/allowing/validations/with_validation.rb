require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      def validate(value, _options = {})
        rule.new.validate(value)
      end
    end
  end
end
