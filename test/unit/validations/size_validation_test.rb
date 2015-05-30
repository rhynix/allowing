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
        errors = @validation.validate('Gregory', :subject)

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_not_exact_size
        errors = @validation.validate('Greg', :subject)

        assert_equal 1, errors.size
      end

      def test_validate_returns_no_errors_if_value_is_in_range
        errors = @range_validation.validate('Gregory', :subject)

        assert errors.empty?
      end

      def test_validate_returns_an_error_if_value_is_not_in_range
        errors = @range_validation.validate('G', :subject)

        assert_equal 1, errors.size
      end

      def test_validate_returns_an_error_if_value_is_nil
        errors = @validation.validate(nil, :subject)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.validate(nil, :subject).first

        assert_equal :size,       error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
