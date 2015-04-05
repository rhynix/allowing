require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class SizeValidation < AttributeValidation
      private

      def valid?(value)
        !value.nil? && correct_size?(value.size)
      end

      def correct_size?(size)
        if rule.is_a?(Range)
          rule.cover?(size)
        else
          rule == size
        end
      end
    end
  end
end
