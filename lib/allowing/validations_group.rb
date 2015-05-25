require 'allowing/helpers/scope_helpers'
require 'allowing/wrapped_validation_builder'

module Allowing
  class ValidationsGroup
    attr_reader :attribute, :validations

    def initialize(validations = [])
      @validations = validations
    end

    def validate(value, errors, subject)
      validations.each do |validation|
        validation.validate(value, errors, subject)
      end
    end
  end
end
