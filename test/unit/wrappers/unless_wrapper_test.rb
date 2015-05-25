require 'test_helper'

module Allowing
  module Wrappers
    class UnlessWrapperTest < Minitest::Test
      def setup
        @mock_validation = Minitest::Mock.new

        @wrapper = UnlessWrapper.new(
          proc { |subject| subject.skip? },
          @mock_validation
        )
      end

      def test_calls_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(skip?: false)
        @mock_validation.expect :validate, true, [:value, subject, []]

        @wrapper.validate(:value, subject, [])

        @mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(skip?: true)

        @wrapper.validate(:value, subject, [])

        @mock_validation.verify
      end
    end
  end
end
