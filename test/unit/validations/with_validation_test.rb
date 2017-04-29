require 'test_helper'

class ErrorValidator
  def call(_subject)
    [:error]
  end
end

module SimpleValidations
  module Validations
    class WithValidationTest < Minitest::Test
      def setup
        @validation = WithValidation.new(ErrorValidator.new)
      end

      def test_type_returns_with
        assert_equal :with, @validation.type
      end

      def test_validate_calls_call_on_validator
        errors = @validation.call(:value)

        assert_equal [:error], errors
      end
    end
  end
end
