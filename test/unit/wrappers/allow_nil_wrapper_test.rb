require 'test_helper'
require 'unit/wrappers/wrapper_test'

module Allowing
  module Wrappers
    class AllowNilWrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation
        @attribute  = :attribute

        @wrapper = AllowNilWrapper.new(@rule, @validation, @attribute)
      end

      def test_calls_validate_on_validation_if_attribute_is_not_nil
        subject = OpenStruct.new(attribute: 'value')

        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [subject, []]

        wrapper = AllowNilWrapper.new(@rule, mock_validation, @attribute)
        wrapper.validate(subject, [])

        mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_attribute_is_nil
        subject = OpenStruct.new(attribute: nil)

        mock_validation = Minitest::Mock.new

        wrapper = AllowNilWrapper.new(@rule, mock_validation, @attribute)
        wrapper.validate(subject, [])

        mock_validation.verify
      end

      def test_calls_validate_on_validation_if_attribute_nil_and_rule_false
        subject = OpenStruct.new(attribute: nil)

        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [subject, []]

        wrapper = AllowNilWrapper.new(false, mock_validation, @attribute)
        wrapper.validate(subject, [])

        mock_validation.verify
      end
    end
  end
end
