require 'allowing/extensions/string'
require 'allowing/validations'

module Allowing
  UnknownValidationError = Class.new(StandardError)

  # TODO: Rename to validation builder
  class AttributeValidationBuilder
    using Extensions::String

    VALIDATION_CLASS_FORMAT = '%{type}Validation'

    def initialize(type, rule, attribute)
      @type      = type
      @rule      = rule
      @attribute = attribute
    end

    def build
      validation = validation_class.new(@rule)
    end

    private

    def validation_class
      Validations.const_get(constant_name)
    rescue NameError
      raise UnknownValidationError,
            "Don't know how to create validation '#{@type}'"
    end

    def constant_name
      VALIDATION_CLASS_FORMAT % { type: @type.to_s.classify }
    end
  end
end
