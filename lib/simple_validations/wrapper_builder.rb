require 'simple_validations/wrappers'

module SimpleValidations
  UnknownWrapperError = Class.new(StandardError)

  class WrapperBuilder
    using Extensions::String

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
      Wrappers.const_get(class_name)
    rescue NameError
      raise UnknownWrapperError,
            "Don't know how to create wrapper '#{@type}'"
    end

    def class_name
      Wrappers.class_name(@type)
    end
  end
end
