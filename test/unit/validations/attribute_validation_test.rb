require 'test_helper'

module Allowing
  module Validations
    module SharedAttributeValidationTest
      def test_sets_the_rule
        assert_equal @rule, @validation.rule
      end

      def test_sets_the_attribute
        assert_equal @attribute, @validation.attribute
      end

      def test_type_returns_the_type_of_the_validation
        assert_equal @type, @validation.type
      end
    end

    class AttributeValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @rule      = true
        @attribute = :attribute
        @type      = :attribute
        @subject   = OpenStruct.new(attribute: :value)

        @validation = AttributeValidation.new(@rule, @attribute)
      end

      def test_validate_raises_not_implemented_error
        assert_raises(NotImplementedError) do
          @validation.validate(@subject, [])
        end
      end
    end
  end
end
