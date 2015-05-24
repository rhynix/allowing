require 'allowing/wrappers/wrapper'
require 'allowing/helpers/scope_helpers'

module Allowing
  module Wrappers
    class AttributesWrapper < Wrapper
      include Helpers::ScopeHelpers

      def validate(value, errors, subject)
        rule.each do |attribute|
          with_scope(attribute, value, errors) do |scoped_value, scoped_errors|
            validation.validate(scoped_value, scoped_errors, subject)
          end
        end
      end
    end
  end
end
