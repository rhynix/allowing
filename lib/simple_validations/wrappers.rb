require 'simple_validations/extensions/string'

require 'simple_validations/wrappers/attributes_wrapper'
require 'simple_validations/wrappers/if_wrapper'
require 'simple_validations/wrappers/unless_wrapper'
require 'simple_validations/wrappers/allow_nil_wrapper'

module SimpleValidations
  module Wrappers
    using Extensions::String

    WRAPPER_CLASS_FORMAT = '%{type}Wrapper'.freeze

    module_function

    def exists?(wrapper)
      const_defined? class_name(wrapper)
    end

    def class_name(wrapper)
      format(WRAPPER_CLASS_FORMAT, type: wrapper.to_s.classify)
    end
  end
end
