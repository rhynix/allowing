require 'test_helper'

module Allowing
  module Wrappers
    class IfWrapperTest < Minitest::Test
      def setup
        @mock_validation = Minitest::Mock.new

        @wrapper = IfWrapper.new(
          proc { |subject| subject.validate? },
          @mock_validation
        )
      end

      def test_calls_validate_on_validation_if_rule_returns_true
        subject = OpenStruct.new(validate?: true)
        @mock_validation.expect :validate, true, [:value, [], subject]

        @wrapper.validate(:value, [], subject)

        @mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(validate?: false)

        @wrapper.validate(:value, [], subject)

        @mock_validation.verify
      end
    end
  end
end
