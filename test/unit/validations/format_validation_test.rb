require 'test_helper'
require 'unit/validations/attribute_validation_test'

module Allowing
  module Validations
    class FormatValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule       = /Greg/
        @attribute  = :attribute
        @type       = :format
        @validation = FormatValidation.new(@rule, attribute: @attribute)
      end

      def test_valid_is_true_if_subject_confirms_to_format
        assert @validation.valid?('Gregory house')
      end

      def test_valid_is_true_if_to_s_confirms_to_format
        attribute = OpenStruct.new(to_s: 'Gregory House')
        assert @validation.valid?(attribute)
      end

      def test_valid_is_false_if_subject_does_not_confirm_to_format
        refute @validation.valid?('James Wilson')
      end

      def test_valid_is_false_if_subject_is_nil
        refute @validation.valid?(nil)
      end
    end
  end
end
