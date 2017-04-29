module SimpleValidations
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

      def call(value, _subject = nil, _options = {})
        [Error.new(@error_name, value: value)]
      end
    end

    class ValidValidation
      def call(_value, _subject = nil, _options = {})
        []
      end
    end
  end
end
