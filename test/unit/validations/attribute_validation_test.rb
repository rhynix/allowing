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
      def setup
        @rule      = true
        @attribute = :attribute
        @subject   = OpenStruct.new(attribute: :value)

        @validation = AttributeValidation.new(@rule, attribute: @attribute)
      end

      def test_valid_raises_not_implemented_error
        assert_raises(NotImplementedError) do
          @validation.valid?(nil)
       end
      end

      def test_validate_adds_no_error_for_a_valid_subject
        errors = []
        @validation.stub :valid?, true do
          @validation.validate(@subject, errors)
        end

        assert errors.empty?
      end

      def test_validate_adds_an_error_for_an_invalid_subject
        errors = []
        @validation.stub :valid?, false do
          @validation.validate(@subject, errors)
        end

        refute errors.empty?
      end

      def test_validate_adds_the_correct_error_for_an_invalid_subject
        errors = []

        @validation.stub :valid?, false do
          @validation.stub :type, :validation_type do
            @validation.validate(@subject, errors)
          end
        end

        assert_equal :validation_type, errors.first.name
        assert_equal @validation, errors.first.validation
        assert_equal [@attribute], errors.first.scope
      end
    end
  end
end
