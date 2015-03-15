require 'test_helper'

Order = Struct.new(:paid_with_card, :card_number)
class OrderValidator < Allowing::Validator
  validates :card_number, presence: true, if: proc {
    |order| order.paid_with_card
  }
end

module Allowing
  module IntegrationTests
    class ValidationsWithOptionsTest < Minitest::Test
      def setup
        @order     = Order.new(true, nil)
        @validator = OrderValidator.new(@order)
      end

      def test_validation_with_if_is_validated_if_condition_is_true
        refute @validator.valid?
      end

      def test_validaiton_with_if_is_not_validated_if_condition_is_false
        @order.paid_with_card = false
        assert @validator.valid?
      end
    end
  end
end
