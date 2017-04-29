module SimpleValidations
  module Wrappers
    class Wrapper
      attr_reader :rule, :validation

      def initialize(rule, validation)
        @rule       = rule
        @validation = validation
      end

      def call(_value, _subject = nil, _options = {})
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
