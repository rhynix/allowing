require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class LengthValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule             = 7
        @attribute        = :name
        @type             = :length
        @range_validation = LengthValidation.new(2..Float::INFINITY, @attribute)
        @validation       = LengthValidation.new(@rule, @attribute)
        @errors           = []

        @object     = OpenStruct.new
      end

      def test_validate_adds_no_errors_if_attribute_is_exact_length
        @object.name = 'Gregory'
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_no_error_if_attribute_is_in_range
        @object.name = 'Gregory'
        @range_validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_an_error_if_attribute_is_not_in_range
        @object.name = 'G'
        @range_validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_not_exact_length
        @object.name = 'Greg'
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_nil
        @object.name = nil
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_raises_error_if_rule_is_invalid
        @object.name = 'Gregory'
        validation = LengthValidation.new('three', @attribute)

        assert_raises(LengthValidation::UnknownLengthError) do
          validation.validate(@object, @errors)
        end
      end
    end
  end
end
