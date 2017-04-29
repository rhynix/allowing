require 'simple_validations/wrappers/conditional_wrapper'

module SimpleValidations
  module Wrappers
    class UnlessWrapper < ConditionalWrapper
      private

      def validate?(_value, subject)
        !rule.call(subject)
      end
    end
  end
end
