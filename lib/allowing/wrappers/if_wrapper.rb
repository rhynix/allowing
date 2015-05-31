require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class IfWrapper < ConditionalWrapper
      private

      def validate?(_value, options)
        rule.call(options[:subject])
      end
    end
  end
end
