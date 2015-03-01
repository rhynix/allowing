require 'allowing/validations/block_validation'
require 'allowing/validation_builder'
require 'allowing/validations_group'
require 'allowing/error'

module Allowing
  IncompleteValidationError = Class.new(StandardError)

  class ValidationsManager
    attr_reader :group

    def initialize(group = nil)
      @group = group
    end

    def define_validations(&block)
      instance_eval(&block)
    end

    def validates(*attributes, **rules, &block)
      guard_complete_validation(rules, &block)

      if block_given? && attributes.any?
        add_nested_validations(attributes, &block)
      elsif block_given?
        add_block_validation(&block)
      else
        add_attribute_validations(attributes, rules)
      end
    end

    private

    def add_nested_validations(attributes, &block)
      attributes.each do |attribute|
        group.validations << ValidationsGroup.new(attribute, &block)
      end
    end

    def add_attribute_validations(attributes, rules)
      attributes.each do |attribute|
        rules.each do |type, rule|
          group.validations << build_validation(type, rule, attribute)
        end
      end
    end

    def add_block_validation(&block)
      group.validations << Validations::BlockValidation.new(&block)
    end

    def build_validation(type, rule, attribute)
      ValidationBuilder.new(type, rule, attribute).build
    end

    def guard_complete_validation(validations, &block)
      unless validations.any? || block_given?
        raise IncompleteValidationError, 'Either block or rules should be provided'
      end
    end
  end
end
