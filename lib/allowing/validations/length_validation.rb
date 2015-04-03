require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class LengthValidation < AttributeValidation
      private

      def valid?(value)
        !value.nil? && correct_length?(value.length)
      end

      def correct_length?(length)
        if rule.is_a?(Range)
          rule.cover?(length)
        else
          rule == length
        end
      end
    end
  end
end
