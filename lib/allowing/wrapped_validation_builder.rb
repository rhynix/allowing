require 'allowing/wrapping_builder'
require 'allowing/validation_builder'
require 'allowing/validations/block_validation'
require 'allowing/validation_dsl'
require 'allowing/validations_group'

module Allowing
  class WrappedValidationBuilder
    using Extensions::String

    def initialize(attributes, rules, &block)
      @attributes = attributes || []
      @rules      = rules || {}
      @block      = block
    end

    def build
      WrappingBuilder.new(unwrapped_validation, wrappers).build
    end

    private

    def unwrapped_validation
      return build_simple_validations if simple_validations?
      return build_nested_validations if nested_validations?
      return build_block_validation   if block_validations?

      fail ArgumentError, 'Wrong argument combination given'
    end

    def build_block_validation
      Validations::BlockValidation.new(&@block)
    end

    def build_nested_validations
      add_attributes_wrapper

      group_validations(ValidationDSL.define(&@block))
    end

    def build_simple_validations
      add_attributes_wrapper

      group_validations(ungrouped_validations)
    end

    def ungrouped_validations
      validations.map { |type, rule| ValidationBuilder.new(type, rule).build }
    end

    def group_validations(validations)
      return validations.first if validations.size == 1

      ValidationsGroup.new(validations)
    end

    def add_attributes_wrapper
      @rules = { attributes: @attributes }.merge(@rules) if @attributes.any?
    end

    def wrappers
      @wrappers = @rules.select { |type, _| Wrappers.exists?(type) }.to_h
    end

    def validations
      @validations = @rules.reject { |type, _| Wrappers.exists?(type) }.to_h
    end

    def block_validations?
      @attributes.empty? && @rules.empty? && @block
    end

    def nested_validations?
      @attributes.any? && @rules.empty? && @block
    end

    def simple_validations?
      @rules.any? && !@block
    end
  end
end
