require 'test_helper'

module SimpleValidations
  module Validations
    class CompositeValidationTest < Minitest::Test
      def setup
        @validation = CompositeValidation.new
      end

      def test_validations_returns_empty_array_by_default
        assert_equal [], @validation.validations
      end

      def test_initialize_sets_validations
        validation = CompositeValidation.new([:validation])
        assert_equal [:validation], validation.validations
      end

      def test_validate_delegates_to_all_validations
        @validation.validations << Doubles::ErrorValidation.new(:error)
        @validation.validations << Doubles::ValidValidation.new

        errors = @validation.call(:value)

        assert_equal [:error], errors.map(&:name)
      end
    end
  end
end
