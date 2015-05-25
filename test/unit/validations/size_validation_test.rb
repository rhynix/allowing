require 'test_helper'

module Allowing
  module Validations
    class SizeValidationTest < Minitest::Test
      def setup
        @rule             = 7
        @range_validation = SizeValidation.new(2..Float::INFINITY)
        @validation       = SizeValidation.new(@rule)
        @errors           = []
      end

      def test_type_returns_size
        assert_equal :size, @validation.type
      end

      def test_validate_adds_no_errors_if_value_is_exact_size
        @validation.validate('Gregory', :subject, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_not_exact_size
        @validation.validate('Greg', :subject, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_no_error_if_value_is_in_range
        @range_validation.validate('Gregory', :subject, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_an_error_if_value_is_not_in_range
        @range_validation.validate('G', :subject, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_value_is_nil
        @validation.validate(nil, :subject, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(nil, :subject, @errors)

        error = @errors.first

        assert_equal :size,       error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
