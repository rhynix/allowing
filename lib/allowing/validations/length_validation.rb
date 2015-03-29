require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class LengthValidation < AttributeValidation
      UnknownLengthError = Class.new(StandardError)

      private

      def valid?(value)
        !value.nil? && correct_length?(value.length)
      end

      def correct_length?(length)
        case rule
        when Range
          length_in_range?(length)
        when Numeric
          exact_length?(length)
        else
          fail UnknownLengthError,
               "Don't know how to interpret as length: #{rule.inspect}"
        end
      end

      def exact_length?(length)
        rule == length
      end

      def length_in_range?(length)
        rule.cover?(length)
      end
    end
  end
end
