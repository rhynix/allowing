require 'allowing/wrappers'
require 'allowing/wrapper_builder'
require 'allowing/validation_builder'
require 'allowing/validations/composite_validation'

module Allowing
  class WrappedValidationBuilder
    using Extensions::String

    def initialize(attributes, rules, &block)
      @attributes = attributes || []
      @rules      = rules || {}
      @block      = block
    end

    def build
      wrap(unwrapped_validation, wrappers_with_attributes)
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
        Validations::CompositeValidation.new(validations)
      end
    end

    def wrappers
      @wrappers ||= @rules.select { |type, _| Wrappers.exists?(type) }.to_h
    end

    def validations
      @validations ||= @rules.reject { |type, _| Wrappers.exists?(type) }.to_h
    end

    def wrap(validation, wrappers)
      wrappers.to_a.reverse.reduce(validation) { |outer_wrapper, (type, rule)|
        WrapperBuilder.new(type, rule, outer_wrapper).build
      }
    end
  end
end
