require 'test_helper'

class ErrorValidator
  def validate(_subject)
    [:error]
  end
end

module Allowing
  module Validations
    class WithValidationTest < Minitest::Test
      def setup
        @validation = WithValidation.new(ErrorValidator)
      end

      def test_type_returns_with
        assert_equal :with, @validation.type
      end

      def test_validate_delegates_to_validator
        errors = @validation.validate(:value, :subject)

        assert_equal [:error], errors
      end
    end
  end
end
