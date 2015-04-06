require 'test_helper'

module Allowing
  class ValidationsGroupTest < Minitest::Test
    def setup
      @group           = ValidationsGroup.new(:attribute)
      @subject         = OpenStruct.new(attribute: :value)

      @group.builder_class = Doubles::ValidationsBuilder
    end

    def test_validations_returns_empty_array_by_default
      assert_equal [], @group.validations
    end

    def test_sets_the_attribute
      assert_equal :attribute, @group.attribute
    end

    def test_builder_class_is_validations_builder_by_default
      @group.builder_class = nil

      assert_equal ValidationsBuilder, @group.builder_class
    end

    def test_validates_adds_the_validations_created_by_builder
      @group.validates(:attribute, presence: true)

      validation = @group.validations.first

      assert validation.is_a?(Validations::PresenceValidation)
      assert_equal true,       validation.rule
      assert_equal :attribute, validation.attribute
    end

    def test_initialize_allows_adding_validations
      group = ValidationsGroup.new do
        validates :attribute, presence: true
      end

      validation = group.validations.first
      assert validation.is_a?(Validations::PresenceValidation)
    end

    def test_validate_calls_validate_on_validations
      mock_validation = Minitest::Mock.new
      mock_validation.expect :validate, true, [:value, []]

      @group.validations << mock_validation
      @group.validate(@subject, [])

      mock_validation.verify
    end

    def test_validate_adds_the_correct_scope_on_error
      error  = Error.new(:name, scope: :nested_attribute)
      errors = []

      @group.validations << Doubles::ErrorValidation.new(error)
      @group.validate(@subject, errors)

      assert_equal [:attribute, :nested_attribute], errors.first.scope
    end

    def test_validate_does_not_affect_scope_of_irrelevant_errors
      error   = Error.new(:error, scope: :initial)
      errors  = [error]

      @group.validate(@subject, errors)
      assert_equal [:initial], error.scope
    end
  end
end
