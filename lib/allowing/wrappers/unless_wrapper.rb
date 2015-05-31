require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class UnlessWrapper < ConditionalWrapper
      private

      def validate?(_value, options)
        !rule.call(options[:subject])
      end
    end
  end
end
