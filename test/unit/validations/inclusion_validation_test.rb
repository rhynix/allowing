require 'test_helper'

module Allowing
  module Validations
    class InclusionValidationTest < Minitest::Test
      def setup
        @validation       = InclusionValidation.new([1, 2, 3])
        @range_validation = InclusionValidation.new(1..10)
      end

      def test_type_returns_inclusion
        assert_equal :inclusion, @validation.type
      end

      def test_validate_returns_no_errors_if_value_is_in_rule
        errors = @validation.validate(3, :subject)

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_not_in_rule
        errors = @validation.validate(4, :subject)

        assert_equal 1, errors.size
      end

      def test_validate_returns_no_errors_if_value_is_in_range
        errors = @range_validation.validate(8, :subject)

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_not_in_range
        errors = @range_validation.validate(11, :subject)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.validate(4, :subject).first

        assert_equal :inclusion,  error.name
        assert_equal @validation, error.validation
        assert_equal 4,           error.value
      end
    end
  end
end
