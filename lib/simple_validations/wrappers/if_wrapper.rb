require 'simple_validations/wrappers/conditional_wrapper'

module SimpleValidations
  module Wrappers
    class IfWrapper < ConditionalWrapper
      private

      def validate?(_value, subject)
        rule.call(subject)
      end
    end
  end
end
