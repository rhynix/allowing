require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class ConditionalWrapper < Wrapper
      def call(value, subject = nil)
        if validate?(value, subject)
          validation.call(value, subject)
        else
          []
        end
      end

      private

      def validate?(_value, _subject)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
