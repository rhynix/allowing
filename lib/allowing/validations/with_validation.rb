require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      alias_method :validator, :rule

      def validate(value, errors, _subject)
        validator.new(value).validate(errors)
      end
    end
  end
end
