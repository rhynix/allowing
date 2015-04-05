require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class PresenceValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule       = true
        @attribute  = :name
        @type       = :presence
        @validation = PresenceValidation.new(@rule, @attribute)
        @errors     = []

        @object     = OpenStruct.new
      end

      def test_validate_adds_no_errors_if_attribute_is_present
        @object.name = 'Gregory House'
        @validation.validate(@object, @errors)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_empty
        @object.name = OpenStruct.new(:empty? => true)
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_empty_string
        @object.name = ''
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_attribute_is_nil
        @object.name = nil
        @validation.validate(@object, @errors)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @object.name = nil
        @validation.validate(@object, @errors)

        error = @errors.first

        assert_equal :presence,   error.name
        assert_equal @validation, error.validation
        assert_equal [:name],     error.scope
        assert_equal nil,         error.value
      end
    end
  end
end
