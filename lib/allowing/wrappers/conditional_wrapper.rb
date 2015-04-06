require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class ConditionalWrapper < Wrapper
      def validate(subject, errors)
        validation.validate(subject, errors) if validate?(subject)
      end

      private

      def validate?(_subject)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
