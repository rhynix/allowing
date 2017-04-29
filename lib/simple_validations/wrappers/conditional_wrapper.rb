require 'simple_validations/wrappers/wrapper'

module SimpleValidations
  module Wrappers
    class ConditionalWrapper < Wrapper
      def call(value, subject = nil, options = {})
        if validate?(value, subject)
          validation.call(value, subject, options)
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
