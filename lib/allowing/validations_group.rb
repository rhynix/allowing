require 'allowing/helpers/scope_helpers'
require 'allowing/validations_builder'

module Allowing
  class ValidationsGroup
    include Helpers::ScopeHelpers

    attr_reader :attribute

    def initialize(validations = [], &block)
      @validations = validations
      instance_eval(&block) if block_given?
    end

    def validations
      @validations ||= []
    end

    def validates(*attributes, **rules, &block)
      built_validations = builder_class.new(attributes, rules, &block).build
      validations.push(built_validations)
    end

    def builder_class
      @builder_class ||= ValidationsBuilder
    end

    def builder_class=(builder_class)
      @builder_class = builder_class
    end

    def validate(value, errors, subject)
      validations.each do |validation|
        validation.validate(value, errors, subject)
      end
    end
  end
end
