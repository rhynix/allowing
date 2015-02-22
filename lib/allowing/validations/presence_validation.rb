module Allowing
  module Validations
    class PresenceValidation < AttributeValidation
      def valid?(value)
        !value.nil? && !value_empty?(value)
      end

      private

      def value_empty?(value)
        value.respond_to?(:empty?) && value.empty?
      end
    end
  end
end
