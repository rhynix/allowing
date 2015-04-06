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
      bare_validations.map do |validation|
        WrappingBuilder.new(validation, wrappers, validation.attribute).build
      end
    end

    private

    def bare_validations
      return build_attribute_validations if attribute_validations?
      return build_block_validations     if block_validations?
      return build_nested_validations    if nested_validations?

      fail ArgumentError, 'Wrong argument combination given'
    end

    def build_attribute_validation(type, rule, attribute)
      AttributeValidationBuilder.new(type, rule, attribute).build
    end

    def build_attribute_validations
      @attributes.flat_map do |attribute|
        validations.map do |type, rule|
          build_attribute_validation(type, rule, attribute)
        end
      end
    end

    def build_block_validations
      [Validations::BlockValidation.new(&@block)]
    end

    def build_nested_validations
      @attributes.map do |attribute|
        ValidationsGroup.new(attribute, &@block)
      end
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
      Wrappers.const_defined?("#{type}_wrapper".classify)
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
