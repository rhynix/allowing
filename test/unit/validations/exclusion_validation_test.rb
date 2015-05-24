require 'test_helper'

module Allowing
  module Validations
    class ExclusionValidationTest < Minitest::Test
      def setup
        @rule             = [1, 2, 3]
        @type             = :exclusion
        @range_validation = ExclusionValidation.new(1..10)
        @validation       = ExclusionValidation.new(@rule)
        @errors           = []
      end

      def test_validate_adds_no_errors_if_value_is_not_rule
        @validation.validate(4, @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_in_rule
        @validation.validate(3, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_no_errors_if_value_is_not_in_range
        @range_validation.validate(11, @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_in_range
        @range_validation.validate(8, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(3, @errors, :subject)

        error = @errors.first

        assert_equal :exclusion,  error.name
        assert_equal @validation, error.validation
        assert_equal 3,           error.value
      end
    end
  end
end
