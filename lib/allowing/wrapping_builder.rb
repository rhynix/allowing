require 'allowing/wrapper_builder'

module Allowing
  class WrappingBuilder
    def initialize(validation, wrappers)
      @validation = validation
      @wrappers   = wrappers.to_a
    end

    def build
      build_next until @wrappers.empty?
      outer_wrapper
    end

    private

    def build_next
      (type, rule) = @wrappers.shift
      next_wrapper = WrapperBuilder.new(type, rule, outer_wrapper).build
      self.outer_wrapper = next_wrapper
    end

    def outer_wrapper
      @outer_wrapper ||= @validation
    end

    def outer_wrapper=(outer_wrapper)
      @outer_wrapper = outer_wrapper
    end
  end
end
