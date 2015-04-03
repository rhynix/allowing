require 'allowing/validations/attribute_validation'

module Allowing
  module Validations
    class BlockValidation
      def initialize(&block)
        @block = block
      end

      def validate(subject, errors)
        @block.call(subject, errors)
      end
    end
  end
end
