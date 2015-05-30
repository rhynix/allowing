require 'test_helper'

module Allowing
  module Validations
    class FormatValidationTest < Minitest::Test
      def setup
        @validation = FormatValidation.new(/Greg/)
      end

      def test_type_returns_format
        assert_equal :format, @validation.type
      end

      def test_validate_returns_no_errors_if_value_confirms_to_format
        errors = @validation.validate('Gregory House')

        assert errors.empty?
      end

      def test_validate_retursn_no_errors_if_to_s_on_value_confirms_to_format
        value  = OpenStruct.new(to_s: 'Gregory House')
        errors = @validation.validate(value)

        assert errors.empty?
      end

      def test_validate_returns_an_error_if_value_does_not_confirm_to_format
        errors = @validation.validate('James Wilson')

        assert_equal 1, errors.size
      end

      def test_validate_returns_an_error_if_value_is_nil
        errors = @validation.validate(nil)

        assert_equal 1, errors.size
      end

      def test_validate_returns_correct_error
        error = @validation.validate(nil).first

        assert_equal :format,     error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
