require 'simple_validations/wrappers/conditional_wrapper'

module SimpleValidations
  module Wrappers
    class AllowNilWrapper < ConditionalWrapper
      private

      def validate?(value, _subject)
        !rule || !value.nil?
      end
    end
  end
end
