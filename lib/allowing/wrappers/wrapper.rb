require 'allowing/extensions/string'

module Allowing
  module Wrappers
    class Wrapper
      using Extensions::String

      attr_reader :rule, :validation, :attribute

      def initialize(rule, validation, attribute = nil)
        @rule       = rule
        @validation = validation
        @attribute  = attribute
      end
    end
  end
end
