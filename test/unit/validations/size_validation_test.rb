require 'test_helper'

module Allowing
  module Validations
    class SizeValidationTest < Minitest::Test
      def setup
        @range_validation = SizeValidation.new(2..Float::INFINITY)
        @validation       = SizeValidation.new(7)
        @errors           = []
      end

      def test_type_returns_size
        assert_equal :size, @validation.type
      end

      def test_validate_returns_no_errors_if_value_is_exact_size
        errors = @validation.call('Gregory')

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_not_exact_size
        errors = @validation.call('Greg')

        assert_equal 1, errors.size
      end

      def test_validate_returns_no_errors_if_value_is_in_range
        errors = @range_validation.call('Gregory')

        assert errors.empty?
      end

      def test_validate_returns_an_error_if_value_is_not_in_range
        errors = @range_validation.call('G')

        assert_equal 1, errors.size
      end

      def test_validate_returns_an_error_if_value_is_nil
        errors = @validation.call(nil)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.call(nil).first

        assert_equal :size,       error.name
        assert_equal @validation, error.validation
        assert_nil   error.value
      end
    end
  end
end
