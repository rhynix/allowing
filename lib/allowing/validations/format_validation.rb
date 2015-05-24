require 'allowing/validations/validation'

module Allowing
  module Validations
    class FormatValidation < Validation
      private

      def valid?(value)
        !value.nil? && value.to_s =~ rule
      end
    end
  end
end
