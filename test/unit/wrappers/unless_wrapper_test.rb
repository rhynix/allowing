require 'test_helper'

module Allowing
  module Wrappers
    class UnlessWrapperTest < Minitest::Test
      def setup
        condition = proc { |subject| subject.validate? }
        @mock_validation = Minitest::Mock.new
        @wrapper = UnlessWrapper.new(condition, @mock_validation)
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_true
        subject = OpenStruct.new(validate?: true)

        @wrapper.validate(subject, [])

        @mock_validation.verify
      end

      def test_calls_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(validate?: false)
        @mock_validation.expect :validate, true, [subject, []]

        @wrapper.validate(subject, [])

        @mock_validation.verify
      end
    end
  end
end
