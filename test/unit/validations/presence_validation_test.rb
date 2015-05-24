require 'test_helper'

module Allowing
  module Validations
    class PresenceValidationTest < Minitest::Test
      def setup
        @rule       = true
        @type       = :presence
        @validation = PresenceValidation.new(@rule)
        @errors     = []
      end

      def test_validate_adds_no_errors_if_value_is_present
        @validation.validate('Gregory House', @errors, :subject)

        assert @errors.empty?
      end

      def test_validate_adds_error_if_value_is_empty
        value = OpenStruct.new(:empty? => true)
        @validation.validate(value, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_value_is_empty_string
        @validation.validate('', @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_error_if_value_is_nil
        @validation.validate(nil, @errors, :subject)

        refute @errors.empty?
      end

      def test_validate_adds_correct_error
        @validation.validate(nil, @errors, :subject)

        error = @errors.first

        assert_equal :presence,   error.name
        assert_equal @validation, error.validation
        assert_equal nil,         error.value
      end
    end
  end
end
