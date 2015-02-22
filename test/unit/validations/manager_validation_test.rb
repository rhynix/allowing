require 'test_helper'

module Allowing
  module Validations
    class ManagerValidationTest < Minitest::Test
      def setup
        @mock_validation = Minitest::Mock.new
        @manager         = OpenStruct.new(validations: [@mock_validation])
        @subject         = OpenStruct.new(attribute: :value)
        @validation      = ManagerValidation.new(@manager, :attribute)
      end

      def test_validate_calls_validate_on_validations_of_manager
        @mock_validation.expect :validate, true, [:value, []]
        @validation.validate(@subject, [])

        @mock_validation.verify
      end

      def test_validate_adds_the_correct_scope_on_error
        errors = []
        @mock_validation.expect :validate, true do |subject, errors|
          errors << Error.new(:name, :nested_attribute)
        end

        @validation.validate(@subject, errors)

        assert_equal [:attribute, :nested_attribute], errors.first.scope

        @mock_validation.verify
      end

      def test_validate_does_not_affect_scope_of_irrelevant_errors
        error = Error.new(:error)
        errors = [error]

        @mock_validation.expect :validate, true, [:value, []]

        @validation.validate(@subject, errors)
        assert_equal [], error.scope
      end
    end
  end
end
