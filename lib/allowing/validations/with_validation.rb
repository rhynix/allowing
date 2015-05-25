require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      alias_method :validator, :rule

      def validate(value, _subject, errors)
        validator.new(value).validate(errors)
      end
    end
  end
end
