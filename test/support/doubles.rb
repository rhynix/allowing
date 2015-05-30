module Doubles
  class ValidationsBuilder
    def initialize(attributes, rules, &_block)
      @attribute = attributes.first
      @rule      = rules.values.first
    end

    def build
      Allowing::Validations::PresenceValidation.new(@rule)
    end
  end

  class ErrorValidation
    def initialize(error)
      @error = error
    end

    def validate(_value, _subject)
      [@error]
    end
  end

  class ValidValidation
    def validate(_value, _subject)
      []
    end
  end
end
