require 'allowing/validations_group'

module Allowing
  class Validator
    attr_reader :subject

    def self.validates(*attributes, **options, &block)
      group.validates(*attributes, **options, &block)
    end

    def self.group
      @group ||= ValidationsGroup.new
    end

    def self.group=(group)
      @group = group
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
