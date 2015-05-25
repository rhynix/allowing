require 'allowing/extensions/string'
require 'allowing/wrapping_builder'
require 'allowing/validation_builder'
require 'allowing/validations/block_validation'

module Allowing
  class WrappedValidationBuilder
    using Extensions::String

    def initialize(attributes, rules, &block)
      @attributes = attributes || []
      @rules      = rules || {}
      @block      = block
    end

    def build
      return build_simple_validations if simple_validations?
      return build_nested_validations if nested_validations?
      return build_block_validation   if block_validations?

      fail ArgumentError, 'Wrong argument combination given'
    end

    private

    def build_bare_validations
      validations.map { |type, rule| ValidationBuilder.new(type, rule).build }
    end

    def build_block_validation
      bare_validation = Validations::BlockValidation.new(&@block)
      WrappingBuilder.new(bare_validation, wrappers).build
    end

    def build_nested_validations
      add_attributes_wrapper

      validations = ValidationDSL.define(&@block)
      validation  = group_validations(validations)

      WrappingBuilder.new(validation, wrappers).build
    end

    def build_simple_validations
      add_attributes_wrapper

      bare_validation = group_validations(build_bare_validations)
      WrappingBuilder.new(bare_validation, wrappers).build
    end

    def wrap_validations(validations)
      validations.map do |validation|
        WrappingBuilder.new(validation, wrappers).build
      end
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
