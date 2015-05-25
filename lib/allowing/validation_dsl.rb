require 'allowing/wrapped_validation_builder'

module Allowing
  class ValidationDSL
    DEFAULT_BUILDER_CLASS = WrappedValidationBuilder
    attr_reader :builder_class

    def self.define(builder_class = DEFAULT_BUILDER_CLASS, &block)
      validations = []
      ValidationDSL.new(validations, builder_class, &block)

      validations
    end

    def initialize(validations = [], builder_class = DEFAULT_BUILDER_CLASS, &block)
      @validations   = validations
      @builder_class = builder_class

      instance_eval(&block) if block_given?
    end

    def validates(*attributes, **rules, &block)
      @validations << builder_class.new(attributes, rules, &block).build
    end
  end
end
