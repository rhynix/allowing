module Allowing
  class ValidationsGroup
    attr_reader :validations

    def initialize(validations = [])
      @validations = validations
    end

    def validate(value, subject = value)
      validations.flat_map { |validation| validation.validate(value, subject) }
    end
  end
end
