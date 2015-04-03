require 'allowing/wrappers'

module Allowing
  UnknownWrapperError = Class.new(StandardError)

  class WrapperBuilder
    using Extensions::String

    WRAPPER_CLASS_FORMAT = '%{type}Wrapper'

    def initialize(type, rule, validation)
      @type       = type
      @rule       = rule
      @validation = validation
    end

    def build
      wrapper_class.new(@rule, @validation)
    end

    private

    def wrapper_class
      Wrappers.const_get(constant_name)
    rescue NameError
      raise UnknownWrapperError,
            "Don't know how to create wrapper '#{@type}'"
    end

    def constant_name
      WRAPPER_CLASS_FORMAT % { type: @type.to_s.classify }
    end
  end
end
