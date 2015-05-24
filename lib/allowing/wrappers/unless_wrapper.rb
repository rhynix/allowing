require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class UnlessWrapper < ConditionalWrapper
      private

      def validate?(_value, subject)
        !rule.call(subject)
      end
    end
  end
end
