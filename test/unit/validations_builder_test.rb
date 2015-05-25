require 'test_helper'

module Allowing
  class ValidationsBuilderTest < Minitest::Test
    def test_build_builds_simple_validation
      builder = ValidationsBuilder.new([], presence: true)
      validation = builder.build

      assert validation.is_a?(Validations::PresenceValidation)
    end

    def test_build_builds_attribute_validation
      builder = ValidationsBuilder.new([:attribute], presence: true)
      validation = builder.build

      assert validation.is_a?(Wrappers::AttributesWrapper)
    end

    def test_build_returns_attribute_validation_with_correct_attributes
      builder = ValidationsBuilder.new([:attr_a, :attr_b], presence: true)
      validation = builder.build

      assert_equal [:attr_a, :attr_b], validation.rule
    end

    def test_build_returns_attribute_validation_with_correct_true_validation
      builder = ValidationsBuilder.new([:attribute], presence: true)
      presence_validation = builder.build.validation

      assert presence_validation.is_a?(Validations::PresenceValidation)
    end

    def test_build_returns_validation_with_correct_rule
      builder = ValidationsBuilder.new([:attribute], presence: true)
      presence_validation = builder.build.validation

      assert_equal true, presence_validation.rule
    end

    def test_build_returns_multiple_validations_with_group
      builder = ValidationsBuilder.new([:a, :b], presence: true, format: /A/)
      attribute_validation = builder.build
      group                = attribute_validation.validation

      assert_equal [:a, :b], attribute_validation.rule

      assert group.is_a?(ValidationsGroup)
      assert_equal 2, group.validations.size
    end

    def test_build_returns_block_validation_for_block_validation
      builder    = ValidationsBuilder.new([], {}) { :block }
      validation = builder.build

      assert validation.is_a?(Validations::BlockValidation)
    end

    def test_build_returns_nested_attribute_validation_for_nested_validations
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute, presence: true
      end

      outer_attribute_validation = builder.build
      inner_attribute_validation = outer_attribute_validation.validation

      assert_equal [:attribute],        outer_attribute_validation.rule
      assert_equal [:nested_attribute], inner_attribute_validation.rule
    end

    def test_build_returns_correct_validation_for_nested_validation
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute, presence: true
      end

      outer_attribute_validation = builder.build
      inner_attribute_validation = outer_attribute_validation.validation
      presence_validation        = inner_attribute_validation.validation

      assert presence_validation.is_a?(Validations::PresenceValidation)
    end

    def test_build_returns_group_for_multiple_nested_validations
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute_a, presence: true
        validates :nested_attribute_b, presence: true
      end

      group = builder.build.validation

      assert group.is_a?(ValidationsGroup)
      assert_equal 2, group.validations.size
    end

    def test_build_wraps_the_validation_with_option
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      attribute_validation = builder.build
      wrapper              = attribute_validation.validation

      assert wrapper.is_a?(Wrappers::IfWrapper)
    end

    def test_build_wrapper_has_correct_rule
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      attribute_validation = builder.build
      wrapper              = attribute_validation.validation

      assert_equal :cond, wrapper.rule
    end

    def test_build_wrapper_has_correct_validation
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      attribute_validation = builder.build
      wrapper              = attribute_validation.validation

      assert wrapper.validation.is_a?(Validations::PresenceValidation)
    end

    def test_raises_error_on_incomplete_validation
      assert_raises(ArgumentError) do
        ValidationsBuilder.new([], {}).build
      end
    end

    def test_raises_error_on_nonexisting_validation
      assert_raises(UnknownValidationError) do
        ValidationsBuilder.new([:attribute], unknown: true).build
      end
    end
  end
end
