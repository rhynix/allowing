require 'allowing/helpers/scope_helpers'
require 'allowing/validations_builder'

module Allowing
  class ValidationsGroup
    include Helpers::ScopeHelpers

    attr_reader :attribute

    def initialize(attribute = nil, &block)
      @attribute = attribute

      instance_eval(&block) if block_given?
    end

    def validations
      @validations ||= []
    end

    def validates(*attributes, **rules, &block)
      built_validations = builder_class.new(attributes, rules, &block).build
      validations.push(*built_validations)
    end

    def builder_class
      @builder_class ||= ValidationsBuilder
    end

    def builder_class=(builder_class)
      @builder_class = builder_class
    end

    def validate(subject, errors)
      with_scope(attribute, subject, errors) do |attr_subject, scoped_errors|
        validations.each do |validation|
          validation.validate(attr_subject, scoped_errors)
        end
      end
    end
  end
end
