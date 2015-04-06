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
        @order     = Order.new(true, 'abc')
        @validator = OrderValidator.new(@order)
      end

      def test_validation_with_unless_is_not_validated_if_condition_is_true
        assert @validator.valid?
      end

      def test_validation_with_unless_is_validated_if_condition_is_false
        @order.trusted = false
        refute @validator.valid?
      end

      def test_validation_with_allow_nil_allows_nil_as_value
        @order.trusted     = false
        @order.card_number = nil

        assert @validator.valid?
      end
    end
  end
end
