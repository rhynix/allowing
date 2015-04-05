require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class ExclusionValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule             = [1, 2, 3]
        @attribute        = :number
        @type             = :exclusion
        @range_validation = ExclusionValidation.new(1..10, @attribute)
        @validation       = ExclusionValidation.new(@rule, @attribute)
        @errors           = []

        @object           = OpenStruct.new
      end

      def test_validate_adds_no_errors_if_attribute_is_not_rule
        @object.number = 4
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_in_rule
        @object.number = 3
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_no_errors_if_attribute_is_not_in_range
        @object.number = 11
        @range_validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_in_range
        @object.number = 8
        @range_validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @object.number = 3
        @validation.validate(@object, @errors)

        error = @errors.first

        assert_equal :exclusion,  error.name
        assert_equal @validation, error.validation
        assert_equal [:number],   error.scope
        assert_equal 3,           error.value
      end
    end
  end
end
