module Allowing
  class ValidationsGroup
    attr_reader :validations

    def initialize(validations = [])
      @validations = validations
    end

    def validate(value, subject)
      validations.flat_map do |validation|
        validation.validate(value, subject)
      end
    end
  end
end
