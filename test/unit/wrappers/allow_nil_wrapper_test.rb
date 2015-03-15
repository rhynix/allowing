require 'test_helper'

module Allowing
  module Wrappers
    class AllowNilWrapperTest < Minitest::Test
      def setup
        @mock_validation = Minitest::Mock.new
        @wrapper = AllowNilWrapper.new(true, @mock_validation)
      end

      def test_calls_validate_on_validation_if_subject_is_not_nil
        subject = Object.new
        @mock_validation.expect :validate, true, [subject, []]

        @wrapper.validate(subject, [])

        @mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_subject_is_nil
        @wrapper.validate(nil, [])

        @mock_validation.verify
      end

      def test_calls_validate_on_validation_if_subject_is_nil_and_rule_is_false
        @mock_validation.expect :validate, true, [nil, []]

        AllowNilWrapper.new(false, @mock_validation).validate(nil, [])

        @mock_validation.verify
      end

      def test_type_returns_correct_type
        assert_equal :allow_nil, AllowNilWrapper.type
      end
    end
  end
end
