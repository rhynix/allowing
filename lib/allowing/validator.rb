require 'allowing/validations_group'
require 'allowing/validation_dsl'

module Allowing
  class Validator
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

    def validate(subject)
      group.validate(subject, subject)
    end

    private

    def group
      self.class.group
    end
  end
end
