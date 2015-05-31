require 'allowing/validations/validation'

module Allowing
  module Validations
    class BlockValidation < Validation
      def initialize(&block)
        @block = block
      end

      def validate(value, options = {})
        @block.call(value, options[:subject])
      end
    end
  end
end
