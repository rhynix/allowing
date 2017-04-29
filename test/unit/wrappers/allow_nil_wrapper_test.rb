require 'test_helper'

module SimpleValidations
  module Wrappers
    class AllowNilWrapperTest < Minitest::Test
      def setup
        @validation = Doubles::ErrorValidation.new(:error)
        @wrapper    = AllowNilWrapper.new(true, @validation)
      end

      def test_validate_returns_errors_from_validation_if_value_is_not_nil
        errors = @wrapper.call(:value, :subject)

        assert_equal [:error], errors.map(&:name)
      end

      def test_validate_returns_no_errors_if_value_is_nil
        errors = @wrapper.call(nil, :subject)

        assert errors.empty?
      end

      def test_validate_always_returns_errors_from_validation_if_rule_is_false
        wrapper = AllowNilWrapper.new(false, @validation)
        errors  = wrapper.call(nil, :subject)

        assert_equal [:error], errors.map(&:name)
      end
    end
  end
end
