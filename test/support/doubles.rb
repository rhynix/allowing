module Doubles
  class ValidationsBuilder
    def initialize(attributes, rules, &_block)
      @attribute = attributes.first
      @rule      = rules.values.first
    end

    def build
      [Allowing::Validations::PresenceValidation.new(@rule, @attribute)]
    end
  end

  class ErrorValidation
    def initialize(error)
      @error = error
    end

    def validate(_subject, errors)
      errors << @error
    end
  end
end
