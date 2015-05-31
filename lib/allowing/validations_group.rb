module Allowing
  class ValidationsGroup
    attr_reader :validations

    def initialize(validations = [])
      @validations = validations
    end

    def validate(value, options = {})
      validations.flat_map { |validation| validation.validate(value, options) }
    end
  end
end
