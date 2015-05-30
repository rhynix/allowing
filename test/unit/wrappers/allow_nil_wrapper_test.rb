require 'test_helper'

module Allowing
  module Wrappers
    class AllowNilWrapperTest < Minitest::Test
      def setup
        @error      = Error.new(:error)
        @validation = Doubles::ErrorValidation.new(@error)
        @wrapper    = AllowNilWrapper.new(true, @validation)
      end

      def test_validate_returns_errors_from_validation_if_value_is_not_nil
        errors = @wrapper.validate(:value, :subject)

        assert_equal [@error], errors
      end

      def test_validate_returns_no_errors_if_value_is_nil
        errors = @wrapper.validate(nil, :subject)

        assert errors.empty?
      end

      def test_validate_always_returns_errors_from_validation_if_rule_is_false
        wrapper = AllowNilWrapper.new(false, @validation)
        errors  = wrapper.validate(nil, :subject)

        assert_equal [@error], errors
      end
    end
  end
end
