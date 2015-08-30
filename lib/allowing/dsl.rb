require 'allowing/wrapped_validation_builder'

module Allowing
  module DSL
    class Capturer
      include DSL

      def capture(&block)
        instance_eval(&block) if block_given?

        captured = validations.dup
        validations.clear

        captured
      end
    end

    def validates(*attributes, **rules, &block)
      validations << builder_class.new(attributes, rules, &block).build
    end

    private

    def builder_class
      WrappedValidationBuilder
    end

    def validations
      @validations ||= []
    end
  end
end
