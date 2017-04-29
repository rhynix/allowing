require 'test_helper'

module SimpleValidations
  module Validations
    class ExclusionValidationTest < Minitest::Test
      def setup
        @validation       = ExclusionValidation.new([1, 2, 3])
        @range_validation = ExclusionValidation.new(1..10)
      end

      def test_type_returns_exclusion
        assert_equal :exclusion, @validation.type
      end

      def test_validate_returns_no_errors_if_value_is_not_rule
        errors = @validation.call(4)

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_in_rule
        errors = @validation.call(3)

        assert_equal 1, errors.size
      end

      def test_validate_returns_no_errors_if_value_is_not_in_range
        errors = @range_validation.call(11)

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_in_range
        errors = @range_validation.call(8)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.call(3).first

        assert_equal :exclusion,  error.name
        assert_equal @validation, error.validation
        assert_equal 3,           error.value
      end
    end
  end
end
