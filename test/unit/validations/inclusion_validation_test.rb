require 'test_helper'

module Allowing
  module Validations
    class InclusionValidationTest < Minitest::Test
      def setup
        @rule             = [1, 2, 3]
        @range_validation = InclusionValidation.new(1..10)
        @validation       = InclusionValidation.new(@rule)
        @errors           = []
      end

      def test_type_returns_inclusion
        assert_equal :inclusion, @validation.type
      end

      def test_validate_adds_no_errors_if_value_is_in_rule
        @validation.validate(3, :subject, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_not_in_rule
        @validation.validate(4, :subject, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_no_errors_if_value_is_in_range
        @range_validation.validate(8, :subject, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_not_in_range
        @range_validation.validate(11, :subject, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(4, :subject, @errors)

        error = @errors.first

        assert_equal :inclusion,  error.name
        assert_equal @validation, error.validation
        assert_equal 4,           error.value
      end
    end
  end
end
