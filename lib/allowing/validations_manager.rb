require 'allowing/validations/block_validation'
require 'allowing/validation_builder'
require 'allowing/error'

module Allowing
  IncompleteValidationError = Class.new(StandardError)

  class ValidationsManager
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def validations
      @validations ||= []
    end

    def validates(attribute = nil, rules = nil, &block)
      guard_complete_validation(rules, &block)

      if block_given? && attribute
        add_nested_validations(attribute, &block)
      elsif block_given?
        add_block_validation(&block)
      else
        add_attribute_validations(attribute, rules)
      end
    end

    private

    def add_nested_validations(attribute, &block)
      manager = ValidationsManager.new(&block)
      validations << Validations::ManagerValidation.new(manager, attribute)
    end

    def add_attribute_validations(attribute, validations_hash)
      validations_hash.each do |type, rule|
        validations << build_validation(type, rule, attribute)
      end
    end

    def add_block_validation(&block)
      validations << Validations::BlockValidation.new(&block)
    end

    def build_validation(type, rule, attribute)
      ValidationBuilder.new(type, rule, attribute).build
    end

    def guard_complete_validation(validations, &block)
      unless validations || block_given?
        raise IncompleteValidationError, 'Either block or rules should be provided'
      end
    end
  end
end
