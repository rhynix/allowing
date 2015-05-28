require 'test_helper'

class AddErrorValidator
  def validate(_subject)
    [Error.new(:dummy, value: :value)]
  end
end

module Allowing
  module Validations
    class WithValidationTest < Minitest::Test
      def setup
        @rule         = AddErrorValidator
        @validation   = WithValidation.new(@rule)
      end

      def test_type_returns_with
        assert_equal :with, @validation.type
      end

      def test_validate_calls_validate_on_validator
        errors = []
        @validation.validate(:value, :subject, errors)

        assert_equal 1, errors.count
      end

      def test_validate_adds_the_correct_error
        errors = []

        @validation.validate(:value, :subject, errors)

        error = errors.first

        assert_equal :dummy,       error.name
        assert_equal nil,          error.validation
        assert_equal :value,       error.value
      end

      def test_validate_does_not_affect_other_errors_scope
        error = Error.new(:old_error)

        @validation.validate(:value, :subject, [error])

        assert_equal [], error.scope
      end
    end
  end
end
