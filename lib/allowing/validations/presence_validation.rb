require 'allowing/validations/validation'

module Allowing
  module Validations
    class PresenceValidation < Validation
      private

      def valid?(value)
        !value.nil? && !value_empty?(value)
      end

      def value_empty?(value)
        value.respond_to?(:empty?) && value.empty?
      end
    end
  end
end
