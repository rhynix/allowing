module Allowing
  module Validations
    class FormatValidation < AttributeValidation
      def valid?(value)
        !value.nil? && value.to_s =~ rule
      end
    end
  end
end
