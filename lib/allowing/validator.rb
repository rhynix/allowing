require 'allowing/validations_manager'

module Allowing
  class Validator
    attr_reader :subject

    def self.validates(attribute = nil, rules = nil, &block)
      manager.validates(attribute, rules, &block)
    end

    def self.manager
      @manager ||= ValidationsManager.new
    end

    def self.manager=(manager)
      @manager = manager
    end

    def self.manager_validation
      @manager_validation ||= Validations::ManagerValidation.new(manager, nil)
    end

    def self.manager_validation=(manager_validation)
      @manager_validation = manager_validation
    end

    def initialize(subject)
      @subject = subject
    end

    def errors
      @errors ||= []
    end

    def valid?
      errors.clear
      validate(subject, errors)
      errors.empty?
    end

    def validate(subject, errors)
      manager_validation.validate(subject, errors)
    end

    private

    def manager_validation
      self.class.manager_validation
    end
  end
end
