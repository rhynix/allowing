require 'allowing/extensions/string'
require 'allowing/wrapping_builder'
require 'allowing/attribute_validation_builder'
require 'allowing/validations/block_validation'

module Allowing
  class ValidationsBuilder
    using Extensions::String

    def initialize(attributes, rules, &block)
      @attributes = attributes || []
      @rules      = rules || {}
      @block      = block
    end

    def build
      return build_attribute_validations if attribute_validations?
      return build_block_validation      if block_validations?
      return build_nested_validations    if nested_validations?

      fail ArgumentError, 'Wrong argument combination given'
    end

    private

    def build_bare_validations
      validations.map do |type, rule|
        AttributeValidationBuilder.new(type, rule, :attribute).build
      end
    end

    def group_validations(validations)
      return validations.first if validations.size == 1

      ValidationsGroup.new(validations)
    end

    # TODO: No longer use validations group for building nested validations
    def ungroup_validations(group)
      return group if group.validations.size > 1

      group.validations.first
    end

    def build_attribute_validation(type, rule, attribute)
      validation = AttributeValidationBuilder.new(type, rule, attribute).build
      Validations::AttributeValidation.new(attribute_validation, attribute)
    end

    def build_attribute_validations
      add_attributes_wrapper
      bare_validation = group_validations(build_bare_validations)

      WrappingBuilder.new(bare_validation,wrappers).build
    end

    def build_block_validation
      bare_validation = Validations::BlockValidation.new(&@block)
      WrappingBuilder.new(bare_validation,wrappers).build
    end

    def build_nested_validations
      add_attributes_wrapper

      validation = ungroup_validations(ValidationsGroup.new(&@block))
      WrappingBuilder.new(validation, wrappers).build
    end

    def wrap_validations(validations)
      validations.map do |validation|
        WrappingBuilder.new(validation, wrappers).build
      end
    end

    def add_attributes_wrapper
      @rules = { attributes: @attributes }.merge(@rules)
    end

    def wrappers
      wrappers_and_validations.first
    end

    def validations
      wrappers_and_validations.last
    end

    def wrappers_and_validations
      @split ||= @rules.partition { |type, _rule| wrapper?(type) }.map(&:to_h)
    end

    def wrapper?(type)
      Wrappers.exists?(type)
    end

    def attribute_validations?
      @attributes.any? && @rules.any? && !@block
    end

    def block_validations?
      @attributes.empty? && @rules.empty? && @block
    end

    def nested_validations?
      @attributes.any? && @rules.empty? && @block
    end
  end
end
