require 'simple_validations/validations/validation'

module SimpleValidations
  module Validations
    class WithValidation < Validation
      def call(value, _subject = nil, _options = {})
        rule.call(value)
      end
    end
  end
end
