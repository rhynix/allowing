require 'allowing/wrapping_builder'
require 'allowing/validation_builder'
require 'allowing/dsl'
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
      WrappingBuilder.new(unwrapped_validation, wrappers_with_attributes).build
    end

    private

    def unwrapped_validation
      group_validations(simple_validations + nested_validations)
    end

    def wrappers_with_attributes
      if @attributes.empty?
        wrappers
      else
        { attributes: @attributes }.merge(wrappers)
      end
    end

    def simple_validations
      validations.map { |type, rule| ValidationBuilder.new(type, rule).build }
    end

    def nested_validations
      DSL.capture(&@block)
    end

    def group_validations(validations)
      if validations.size == 1
        validations.first
      else
        ValidationsGroup.new(validations)
      end
    end

    def wrappers
      @wrappers ||= @rules.select { |type, _| Wrappers.exists?(type) }.to_h
    end

    def validations
      @validations ||= @rules.reject { |type, _| Wrappers.exists?(type) }.to_h
    end
  end
end
