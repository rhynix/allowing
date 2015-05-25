require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class ConditionalWrapper < Wrapper
      def validate(value, subject, errors)
        validation.validate(value, subject, errors) if validate?(value, subject)
      end

      private

      def validate?(_value, _subject)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
