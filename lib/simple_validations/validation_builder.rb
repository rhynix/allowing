require 'simple_validations/extensions/string'
require 'simple_validations/validations'

module SimpleValidations
  UnknownValidationError = Class.new(StandardError)

  class ValidationBuilder
    using Extensions::String

    VALIDATION_CLASS_FORMAT = '%{type}Validation'.freeze

    def initialize(type, rule)
      @type = type
      @rule = rule
    end

    def build
      validation_class.new(@rule)
    end

    private

    def validation_class
      Validations.const_get(constant_name)
    rescue NameError
      raise UnknownValidationError,
            "Don't know how to create validation '#{@type}'"
    end

    def constant_name
      format(VALIDATION_CLASS_FORMAT, type: @type.to_s.classify)
    end
  end
end
