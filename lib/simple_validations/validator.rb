require 'simple_validations/validations/composite_validation'
require 'simple_validations/dsl'

module SimpleValidations
  class Validator
    extend DSL

    def self.group
      @group ||= Validations::CompositeValidation.new
    end

    def self.group=(group)
      @group = group
    end

    def self.validations
      group.validations
    end

    def initialize(options = {})
      @options = default_options.merge(options)
    end

    def call(subject)
      group.call(subject, subject, @options)
    end

    private

    def default_options
      {}
    end

    def group
      self.class.group
    end
  end
end
