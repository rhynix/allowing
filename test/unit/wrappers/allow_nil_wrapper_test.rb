require 'test_helper'
require 'unit/wrappers/wrapper_test'

module Allowing
  module Wrappers
    class AllowNilWrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation

        @wrapper = AllowNilWrapper.new(@rule, @validation)
      end

      def test_calls_validate_on_validation_if_subject_is_not_nil
        subject = Object.new

        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [subject, []]

        wrapper = AllowNilWrapper.new(@rule, mock_validation)
        wrapper.validate(subject, [])

        mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_subject_is_nil
        subject = nil

        mock_validation = Minitest::Mock.new

        wrapper = AllowNilWrapper.new(@rule, mock_validation)
        wrapper.validate(subject, [])

        mock_validation.verify
      end

      def test_calls_validate_on_validation_if_subject_is_nil_and_rule_is_false
        subject = nil

        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [nil, []]

        wrapper = AllowNilWrapper.new(false, mock_validation)
        wrapper.validate(subject, [])

        mock_validation.verify
      end
    end
  end
end
