require 'test_helper'

class ValidationsBuilderDouble
  def initialize(attributes, rules, &_block)
    @attribute = attributes.first
    @rule      = rules.values.first
  end

  def build
    [Allowing::Validations::PresenceValidation.new(@rule, @attribute)]
  end
end

module Allowing
  class ValidationsGroupTest < Minitest::Test
    def setup
      @mock_validation = Minitest::Mock.new
      @group           = ValidationsGroup.new(:attribute)
      @subject         = OpenStruct.new(attribute: :value)

      @group.builder_class = ValidationsBuilderDouble
    end

    def test_validations_returns_empty_array_by_default
      assert_equal [], ValidationsGroup.new.validations
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
      @group.validations << @mock_validation

      @mock_validation.expect :validate, true, [:value, []]
      @group.validate(@subject, [])

      @mock_validation.verify
    end

    def test_validate_adds_the_correct_scope_on_error
      @group.validations << @mock_validation

      all_errors = []
      @mock_validation.expect :validate, true do |_subject, errors|
        errors << Error.new(:name, scope: :nested_attribute)
      end

      @group.validate(@subject, all_errors)

      assert_equal [:attribute, :nested_attribute], all_errors.first.scope

      @mock_validation.verify
    end

    def test_validate_does_not_affect_scope_of_irrelevant_errors
      @group.validations << @mock_validation

      error = Error.new(:error)
      errors = [error]

      @mock_validation.expect :validate, true, [:value, []]

      @group.validate(@subject, errors)
      assert_equal [], error.scope
    end
  end
end
