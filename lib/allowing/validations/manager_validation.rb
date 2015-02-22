require 'allowing/helpers/scope_helpers'

module Allowing
  module Validations
    class ManagerValidation
      include Helpers::ScopeHelpers
      attr_reader :manager, :attribute

      def initialize(manager, attribute)
        @manager   = manager
        @attribute = attribute
      end

      def validate(subject, errors)
        with_scope(attribute, subject, errors) do |subject, errors|
          validations.each do |validation|
            validation.validate(subject, errors)
          end
        end
      end

      private

      def validations
        @manager.validations
      end
    end
  end
end
