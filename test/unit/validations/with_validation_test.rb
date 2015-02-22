require 'test_helper'
require 'unit/validations/attribute_validation_test'

class AddErrorValidator < Allowing::Validator
  def validate(subject, errors)
    errors << Error.new(:error)
  end
end

module Allowing
  module Validations
    class WithValidationTest < Minitest::Test
      include SharedAttributeValidationTest

      def setup
        @mock_validator = Minitest::Mock.new

        @rule         = AddErrorValidator
        @attribute    = :attribute
        @type         = :with
        @validation   = WithValidation.new(@rule, @attribute)
        @subject      = OpenStruct.new(attribute: :value)
      end

      def test_validate_calls_validate_on_validator
        errors = []
        @validation.validate(@subject, errors)

        assert_equal 1, errors.count
      end

      def test_validate_sets_the_correct_scope_on_the_errors
        errors = []

        @validation.validate(@subject, errors)

        assert_equal [:attribute], errors.first.scope
      end

      def test_validate_does_not_affect_other_errors_scope
        error = Error.new(:old_error)
        @validation.validate(@subject, [error])

        assert_equal [], error.scope
      end
    end
  end
end
