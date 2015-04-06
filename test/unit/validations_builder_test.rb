require 'test_helper'

module Allowing
  class ValidationsBuilderTest < Minitest::Test
    def test_build_returns_attribute_validation_for_attribute_validation
      builder = ValidationsBuilder.new([:attribute], presence: true)
      validation = builder.build.first

      assert validation.is_a?(Validations::PresenceValidation)
    end

    def test_build_returns_validation_with_correct_attribute_for_attr_validation
      builder = ValidationsBuilder.new([:attribute], presence: true)
      validation = builder.build.first

      assert_equal :attribute, validation.attribute
    end

    def test_build_returns_validation_with_correct_rule_for_attr_validation
      builder = ValidationsBuilder.new([:attribute], presence: true)
      validation = builder.build.first

      assert_equal true, validation.rule
    end

    def test_build_returns_multiple_validations_for_attr_validation
      builder = ValidationsBuilder.new([:a, :b], presence: true, format: /A/)
      validations = builder.build

      assert_equal 4, validations.size
    end

    def test_build_returns_block_validation_for_block_validation
      builder    = ValidationsBuilder.new([], {}) { :block }
      validation = builder.build.first

      assert validation.is_a?(Validations::BlockValidation)
    end

    def test_build_returns_group_for_nested_validations
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute, presence: true
      end

      group = builder.build.first
      assert group.is_a?(ValidationsGroup)
    end

    def test_build_retursn_group_with_correct_attribute_for_nested_validations
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute, presence: true
      end

      group = builder.build.first
      assert_equal :attribute, group.attribute
    end

    def test_build_returns_group_with_correct_validations_for_nested_validations
      builder = ValidationsBuilder.new([:attribute], {}) do
        validates :nested_attribute, presence: true
      end

      group = builder.build.first
      assert_equal 1, group.validations.size
    end

    def test_build_returns_multiple_groups_for_nested_validations
      builder = ValidationsBuilder.new([:a, :b], {}) do
        validates :c, presence: true
      end

      groups = builder.build
      assert_equal 2, groups.size
    end

    def test_build_wraps_the_validation_with_option
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      wrapper = builder.build.first
      assert wrapper.is_a?(Wrappers::IfWrapper)
    end

    def test_build_wrapper_has_correct_rule
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      wrapper = builder.build.first
      assert_equal :cond, wrapper.rule
    end

    def test_build_wrapper_has_correct_validation
      builder = ValidationsBuilder.new([:attribute], presence: true, if: :cond)

      wrapper = builder.build.first
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
