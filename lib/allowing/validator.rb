require 'allowing/validations_group'
require 'allowing/validation_dsl'

module Allowing
  class Validator
    attr_reader :subject

    def self.validates(*attributes, **options, &block)
      dsl.validates(*attributes, **options, &block)
    end

    def self.group
      @group ||= ValidationsGroup.new
    end

    def self.group=(group)
      @group = group
    end

    def self.dsl=(dsl)
      @dsl = dsl
    end

    def self.dsl
      @dsl ||= ValidationDSL.new(group.validations)
    end

    def initialize(subject)
      @subject = subject
    end

    def errors
      @errors ||= []
    end

    def valid?
      errors.clear
      validate(errors)
      errors.empty?
    end

    def validate(errors)
      group.validate(subject, errors, subject)
    end

    private

    def group
      self.class.group
    end
  end
end
