require 'test_helper'

module Allowing
  module Validations
    class SizeValidationTest < Minitest::Test
      def setup
        @rule             = 7
        @type             = :size
        @range_validation = SizeValidation.new(2..Float::INFINITY)
        @validation       = SizeValidation.new(@rule)
        @errors           = []
      end

      def test_validate_adds_no_errors_if_value_is_exact_size
        @validation.validate('Gregory', @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_not_exact_size
        @validation.validate('Greg', @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_no_error_if_value_is_in_range
        @range_validation.validate('Gregory', @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_an_error_if_value_is_not_in_range
        @range_validation.validate('G', @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_value_is_nil
        @validation.validate(nil, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(nil, @errors, :subject)

        error = @errors.first

        assert_equal :size,       error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
