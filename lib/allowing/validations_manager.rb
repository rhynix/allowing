require 'allowing/extensions/string'
require 'allowing/validations/block_validation'
require 'allowing/validation_builder'
require 'allowing/validations_group'
require 'allowing/wrappers'
require 'allowing/wrapping_builder'
require 'allowing/error'

module Allowing
  IncompleteValidationError = Class.new(StandardError)

  class ValidationsManager
    using Extensions::String

    attr_reader :group

    def initialize(group)
      @group = group
    end

    def define_validations(&block)
      instance_eval(&block)
    end

    def validates(*attributes, **rules, &block)
      guard_complete_validation(rules, &block)

      (wrappers, validations) = extract_wrappers_and_validations(rules)

      validations         = create_validations(attributes, validations, &block)
      wrapped_validations = wrap_validations(validations, wrappers)

      group.validations.push(*wrapped_validations)
    end

    private

    def create_validations(attributes, rules, &block)
      if block_given? && attributes.any?
        nested_validations(attributes, &block)
      elsif block_given?
        [block_validation(&block)]
      else
        attribute_validations(attributes, rules)
      end
    end

    def nested_validations(attributes, &block)
      attributes.map { |attr| ValidationsGroup.new(attr, &block) }
    end

    def attribute_validations(attributes, rules)
      attributes.map do |attribute|
        rules.map do |type, rule|
          ValidationBuilder.new(type, rule, attribute).build
        end
      end.flatten
    end

    def block_validation(&block)
      Validations::BlockValidation.new(&block)
    end

    def guard_complete_validation(validations)
      return if validations.any? || block_given?
      fail IncompleteValidationError, 'Either block or rules should be provided'
    end

    def extract_wrappers_and_validations(rules)
      rules.partition { |type, _rule| wrapper?(type) }.map(&:to_h)
    end

    def wrapper?(type)
      Wrappers.const_defined?("#{type}_wrapper".classify)
    end

    def wrap_validations(validations, wrappers)
      validations.map do |validation|
        WrappingBuilder.new(validation, wrappers).build
      end
    end
  end
end
