require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      def validate(value, _subject, errors)
        new_errors = rule.new.validate(value)
        errors.push(*new_errors)
      end
    end
  end
end
