require 'allowing/wrapper_builder'

module Allowing
  class WrappingBuilder
    def initialize(validation, wrappers, attribute)
      @validation = validation
      @wrappers   = wrappers.to_a
      @attribute  = attribute
    end

    def build
      self.outer_wrapper = build_next until @wrappers.empty?
      outer_wrapper
    end

    private

    def build_next
      (type, rule) = @wrappers.pop
      WrapperBuilder.new(type, rule, @attribute, outer_wrapper).build
    end

    def outer_wrapper
      @outer_wrapper ||= @validation
    end

    def outer_wrapper=(outer_wrapper)
      @outer_wrapper = outer_wrapper
    end
  end
end
