module SimpleValidations
  module Validations
    class CompositeValidation
      attr_reader :validations

      def initialize(validations = [])
        @validations = validations
      end

      def call(value, subject = nil, options = {})
        validations.flat_map { |val| val.call(value, subject, options) }
      end
    end
  end
end
