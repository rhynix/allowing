require 'test_helper'

module Allowing
  module Validations
    class FormatValidationTest < Minitest::Test
      def setup
        @rule       = /Greg/
        @type       = :format
        @validation = FormatValidation.new(@rule)
        @errors     = []
      end

      def test_validate_adds_no_errors_if_value_confirms_to_format
        @validation.validate('Gregory House', @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_no_errors_if_to_s_on_value_confirms_to_format
        value = OpenStruct.new(to_s: 'Gregory House')
        @validation.validate(value, @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_an_error_if_value_does_not_confirm_to_format
        @validation.validate('James Wilson', @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_an_error_if_value_is_nil
        @validation.validate(nil, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(nil, @errors, :subject)

        error = @errors.first

        assert_equal :format,     error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
