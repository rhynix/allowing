require 'test_helper'
require 'unit/wrappers/wrapper_test'

module Allowing
  module Wrappers
    class IfWrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = proc { |subject| subject.validate? }
        @validation = :validation
        @attribute  = :attribute

        @wrapper = IfWrapper.new(@rule, @validation, @attribute)
      end

      def test_calls_validate_on_validation_if_rule_returns_true
        subject = OpenStruct.new(validate?: true)

        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [subject, []]

        wrapper = IfWrapper.new(@rule, mock_validation)
        wrapper.validate(subject, [])

        mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(validate?: false)

        mock_validation = Minitest::Mock.new

        wrapper = IfWrapper.new(@rule, mock_validation)
        wrapper.validate(subject, [])

        mock_validation.verify
      end
    end
  end
end
