require 'allowing/validations/validation'

module Allowing
  module Validations
    class BlockValidation < Validation
      def initialize(&block)
        @block = block
      end

      def validate(subject, errors)
        @block.call(subject, errors)
      end
    end
  end
end
