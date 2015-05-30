module Allowing
  module Wrappers
    class Wrapper
      attr_reader :rule, :validation

      def initialize(rule, validation)
        @rule       = rule
        @validation = validation
      end

      def validate(_value, _subject)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
