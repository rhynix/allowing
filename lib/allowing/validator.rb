require 'allowing/validations/composite_validation'
require 'allowing/dsl'

module Allowing
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

    def call(subject)
      group.call(subject, subject)
    end

    private

    def group
      self.class.group
    end
  end
end
