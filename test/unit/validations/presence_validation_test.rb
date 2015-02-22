require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class PresenceValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule       = true
        @attribute  = :attribute
        @type       = :presence
        @validation = PresenceValidation.new(@rule, attribute: @attribute)
      end

      def test_valid_is_true_if_attribute_has_a_value
        assert @validation.valid?('value')
      end

      def test_valid_is_false_if_subject_is_empty
        attribute = OpenStruct.new(:empty? => true)
        refute @validation.valid?(attribute)
      end

      def test_valid_is_false_if_subject_is_empty_string
        refute @validation.valid?('')
      end

      def test_valid_is_false_if_subject_is_nil
        refute @validation.valid?(nil)
      end
    end
  end
end
