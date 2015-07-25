require 'test_helper'

Order = Struct.new(:trusted, :card_number)

class OrderValidator < Allowing::Validator
  validates :card_number,
            format: /^d+$/,
            unless: proc { |order| order.trusted },
            allow_nil: true
end

module Allowing
  module IntegrationTests
    class ValidationsWithOptionsTest < Minitest::Test
      def setup
        @subject   = Order.new(true, 'abc')
        @validator = OrderValidator.new
      end

      def test_validate_returns_no_errors_if_unless_conditions_is_not_met
        assert @validator.call(@subject).empty?
      end

      def test_validate_returns_no_error_if_unless_conditions_is_met
        @subject.trusted = false

        refute @validator.call(@subject).empty?
      end

      def test_validate_returns_no_errors_if_nil_value_is_given
        @subject.trusted     = false
        @subject.card_number = nil

        assert @validator.call(@subject).empty?
      end
    end
  end
end
