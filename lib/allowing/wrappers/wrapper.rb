require 'allowing/extensions/string'

module Allowing
  module Wrappers
    class Wrapper
      using Extensions::String

      attr_reader :rule, :validation

      def initialize(rule, validation)
        @rule       = rule
        @validation = validation
      end
    end
  end
end
