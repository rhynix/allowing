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

      def test_calls_validate_on_validation_if_value_is_not_nil
        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [:value, [], :subject]

        wrapper = AllowNilWrapper.new(@rule, mock_validation)
        wrapper.validate(:value, [], :subject)

        mock_validation.verify
      end

      def test_does_not_call_validate_on_validation_if_value_is_nil
        mock_validation = Minitest::Mock.new

        wrapper = AllowNilWrapper.new(@rule, mock_validation)
        wrapper.validate(nil, [], :subject)

        mock_validation.verify
      end

      def test_calls_validate_on_validation_if_value_nil_and_rule_false
        mock_validation = Minitest::Mock.new
        mock_validation.expect :validate, true, [nil, [], :subject]

        wrapper = AllowNilWrapper.new(false, mock_validation)
        wrapper.validate(nil, [], :subject)

        mock_validation.verify
      end
    end
  end
end
