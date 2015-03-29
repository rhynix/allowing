require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class LengthValidation < AttributeValidation
      private

      def valid?(value)
        !value.nil? && correct_length?(value.length)
      end

      def correct_length?(length)
        case rule
        when Range
          length_in_range?(length)
        else
          equal_length?(length)
        end
      end

      def equal_length?(length)
        rule == length
      end

      def length_in_range?(length)
        rule.cover?(length)
      end
    end
  end
end
