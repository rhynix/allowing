require 'test_helper'

module Allowing
  module Validations
    class MethodValidationTest < Minitest::Test
      def setup
        @mock_validator = Minitest::Mock.new

        @validation = MethodValidation.new(:validate_something)
      end

      def test_type_returns_method
        assert_equal :method, @validation.type
      end

      def test_validate_delegates_to_validator_method
        @mock_validator.expect :validate_something, [], [:value]

        @validation.validate(:value, validator: @mock_validator)

        @mock_validator.verify
      end
    end
  end
end
