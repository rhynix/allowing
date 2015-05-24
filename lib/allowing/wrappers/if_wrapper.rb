require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class IfWrapper < ConditionalWrapper
      private

      def validate?(_value, subject)
        rule.call(subject)
      end
    end
  end
end
