module Allowing
  class ValidationsGroup
    attr_reader :validations

    def initialize(validations = [])
      @validations = validations
    end

    def validate(value, subject, errors)
      validations.each do |validation|
        validation.validate(value, subject, errors)
      end
    end
  end
end
