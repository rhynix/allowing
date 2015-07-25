require 'allowing/wrapping_builder'
require 'allowing/validation_builder'
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
      add_attributes_wrapper

      group_validations(simple_validations + nested_validations)
    end

    def add_attributes_wrapper
      @rules = { attributes: @attributes }.merge(@rules) if @attributes.any?
    end

    def nested_validations
      add_attributes_wrapper

      ValidationDSL.define(&@block)
    end

    def simple_validations
      validations.map { |type, rule| ValidationBuilder.new(type, rule).build }
    end

    def group_validations(validations)
      return validations.first if validations.size == 1

      ValidationsGroup.new(validations)
    end

    def wrappers
      @wrappers ||= @rules.select { |type, _| Wrappers.exists?(type) }.to_h
    end

    def validations
      @validations ||= @rules.reject { |type, _| Wrappers.exists?(type) }.to_h
    end
  end
end
