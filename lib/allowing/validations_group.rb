module Allowing
  class ValidationsGroup
    attr_reader :validations

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
