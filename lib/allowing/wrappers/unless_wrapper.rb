require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class UnlessWrapper < Wrapper
      def validate(subject, errors)
        validation.validate(subject, errors) if validate?(subject)
      end

      private

      def validate?(subject)
        !rule.call(subject)
      end
    end
  end
end
