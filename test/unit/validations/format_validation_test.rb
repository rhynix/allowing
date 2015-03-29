require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class FormatValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule       = /Greg/
        @attribute  = :name
        @type       = :format
        @validation = FormatValidation.new(@rule, @attribute)
        @errors     = []

        @object     = OpenStruct.new
      end

      def test_validate_adds_no_errors_if_attribute_confirms_to_format
        @object.name = 'Gregory House'
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_no_errors_if_to_s_on_attribute_confirms_to_format
        @object.name = OpenStruct.new(to_s: 'Gregory House')
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_an_error_if_attribute_does_not_confirm_to_format
        @object.name = 'James Wilson'
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_an_error_if_attribute_is_nil
        @object.name = nil
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @object.name = nil
        @validation.validate(@object, @errors)

        error = @errors.first

        assert_equal :format,     error.name
        assert_equal @validation, error.validation
        assert_equal [:name],     error.scope
      end
    end
  end
end
