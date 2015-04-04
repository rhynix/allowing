require 'allowing/helpers/scope_helpers'

module Allowing
  class ValidationsGroup
    include Helpers::ScopeHelpers

    attr_reader :attribute

    def initialize(attribute = nil, validations = nil, &block)
      @validations = validations
      @attribute   = attribute

      manager.define_validations(&block) if block_given?
    end

    def validations
      @validations ||= []
    end

    def manager
      @manager ||= ValidationsManager.new(self)
    end

    def manager=(manager)
      @manager = manager
    end

    def validates(*attributes, **options, &block)
      manager.validates(*attributes, **options, &block)
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
