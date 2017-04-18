require 'test_helper'

module Allowing
  module Validations
    class PresenceValidationTest < Minitest::Test
      def setup
        @rule       = true
        @validation = PresenceValidation.new(@rule)
        @errors     = []
      end

      def test_type_returns_presence
        assert_equal :presence, @validation.type
      end

      def test_validate_returns_no_errors_if_value_is_present
        errors = @validation.call('Gregory House')

        assert errors.empty?
      end

      def test_validate_returns_error_if_value_is_empty
        value  = OpenStruct.new(empty?: true)
        errors = @validation.call(value)

        assert_equal 1, errors.size
      end

      def test_validate_returns_error_if_value_is_empty_string
        errors = @validation.call('')

        assert_equal 1, errors.size
      end

      def test_validate_returns_error_if_value_is_nil
        errors = @validation.call(nil)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.call(nil).first

        assert_equal :presence,   error.name
        assert_equal @validation, error.validation
        assert_nil   error.value
      end
    end
  end
end
