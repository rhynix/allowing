require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class SizeValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule             = 7
        @attribute        = :name
        @type             = :size
        @range_validation = SizeValidation.new(2..Float::INFINITY, @attribute)
        @validation       = SizeValidation.new(@rule, @attribute)
        @errors           = []

        @object           = OpenStruct.new
      end

      def test_validate_adds_no_errors_if_attribute_is_exact_size
        @object.name = 'Gregory'
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_not_exact_size
        @object.name = 'Greg'
        @validation.validate(@object, @errors)

        refute @errors.empty?
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

      def test_validate_adds_error_if_attribute_is_nil
        @object.name = nil
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end
    end
  end
end
