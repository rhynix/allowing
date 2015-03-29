require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class FormatValidation < AttributeValidation
      private

      def valid?(value)
        !value.nil? && value.to_s =~ rule
      end
    end
  end
end
