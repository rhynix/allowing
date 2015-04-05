require 'test_helper'
require 'unit/validations/attribute_validation_test'

class AddErrorValidator
  def initialize(_subject)
  end

  def validate(errors)
    errors << Error.new(:dummy, value: :value)
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

      def test_validate_adds_the_correct_error
        errors = []

        @validation.validate(@subject, errors)

        error = errors.first

        assert_equal :dummy,       error.name
        assert_equal nil,          error.validation
        assert_equal [:attribute], error.scope
        assert_equal :value,       error.value
      end

      def test_validate_does_not_affect_other_errors_scope
        error = Error.new(:old_error)

        @validation.validate(@subject, [error])

        assert_equal [], error.scope
      end
    end
  end
end
