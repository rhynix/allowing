require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      def validate(value, _subject, errors)
        rule.new(value).validate(errors)
      end
    end
  end
end
