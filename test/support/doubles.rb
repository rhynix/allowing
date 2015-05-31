module Allowing
  module Doubles
    class ValidationsBuilder
      def initialize(attributes, rules, &_block)
        @attribute = attributes.first
        @rule      = rules.values.first
      end

      def build
        Validations::PresenceValidation.new(@rule)
      end
    end

    class ErrorValidation
      def initialize(error_name)
        @error_name = error_name
      end

      def validate(_value, _options = {})
        [Error.new(@error_name)]
      end
    end

    class ValidValidation
      def validate(_value, _options = {})
        []
      end
    end
  end
end
