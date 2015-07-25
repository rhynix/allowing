require 'allowing/validations/validation'

module Allowing
  module Validations
    class WithValidation < Validation
      def call(value, _subject = nil)
        rule.call(value)
      end
    end
  end
end
