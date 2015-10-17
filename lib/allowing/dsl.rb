require 'allowing/wrapped_validation_builder'

module Allowing
  module DSL
    class Capturer
      include DSL

      def initialize(&blk)
        instance_eval(&blk) if block_given?
      end
    end

    def self.capture(&blk)
      Capturer.new(&blk).validations
    end

    def validates(*attributes, **rules, &blk)
      validations << WrappedValidationBuilder.new(attributes, rules, &blk).build
    end

    def validations
      @validations ||= []
    end
  end
end
