module Allowing
  class ValidationsGroup
    attr_reader :validations

    def initialize(validations = [])
      @validations = validations
    end

    def call(value, subject = nil)
      validations.flat_map { |validation| validation.call(value, subject) }
    end
  end
end
