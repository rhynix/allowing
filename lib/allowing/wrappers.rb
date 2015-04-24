require 'allowing/extensions/string'

require 'allowing/wrappers/if_wrapper'
require 'allowing/wrappers/unless_wrapper'
require 'allowing/wrappers/allow_nil_wrapper'

module Allowing
  module Wrappers
    using Extensions::String

    WRAPPER_CLASS_FORMAT = '%{type}Wrapper'

    module_function

    def exists?(wrapper)
      const_defined? class_name(wrapper)
    end

    def class_name(wrapper)
      WRAPPER_CLASS_FORMAT % { type: wrapper.to_s.classify }
    end
  end
end
