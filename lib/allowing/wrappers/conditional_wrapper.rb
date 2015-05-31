require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class ConditionalWrapper < Wrapper
      def validate(value, options = {})
        return [] unless validate?(value, options)

        validation.validate(value, options)
      end

      private

      def validate?(_value, _options)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
