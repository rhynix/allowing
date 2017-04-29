require 'simple_validations/wrappers/wrapper'

module SimpleValidations
  module Wrappers
    class AttributesWrapper < Wrapper
      DEFAULT_STRATEGY = :send

      STRATEGIES = {
        send:       ->(value, attribute) { value.public_send(attribute) },
        symbol_key: ->(value, attribute) { value[attribute.to_sym]      },
        string_key: ->(value, attribute) { value[attribute.to_s]        }
      }.freeze

      def call(value, subject = nil, options = {})
        rule.flat_map do |attribute|
          validate_attribute(attribute, value, subject, options)
        end
      end

      private

      def validate_attribute(attribute, value, subject, options)
        strategy      = options.fetch(:attribute_strategy) { DEFAULT_STRATEGY }
        scoped_value  = strategy_for(strategy).call(value, attribute)
        errors        = validation.call(scoped_value, subject, options)

        scoped_errors_for(attribute, errors)
      end

      def scoped_errors_for(attribute, errors)
        errors.map { |error| error.scoped(attribute) }
      end

      def strategy_for(strategy_or_strategy_name)
        if strategy_or_strategy_name.respond_to?(:call)
          strategy_or_strategy_name
        else
          STRATEGIES.fetch(strategy_or_strategy_name)
        end
      end
    end
  end
end
