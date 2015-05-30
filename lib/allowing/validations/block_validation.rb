require 'allowing/validations/validation'

module Allowing
  module Validations
    class BlockValidation < Validation
      def initialize(&block)
        @block = block
      end

      def validate(value, subject)
        @block.call(value, subject)
      end
    end
  end
end
