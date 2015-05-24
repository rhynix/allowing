require 'allowing/validations/validation'

module Allowing
  module Validations
    class BlockValidation < Validation
      def initialize(&block)
        @block = block
      end

      def validate(value, errors, subject)
        @block.call(value, errors)
      end
    end
  end
end
