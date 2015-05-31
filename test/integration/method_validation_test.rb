require 'test_helper'

Visitor = Struct.new(:name, :has_ticket)
Visit   = Struct.new(:visitor, :date)

class VisitValidator < Allowing::Validator
  validates :date, presence: :true
  validates :visitor, method: :validate_ticket

  def validate_ticket(visitor)
    return [] if visitor.has_ticket

    [Allowing::Error.new(:no_ticket)]
  end
end

module Allowing
  module IntegrationTests
    class MethodValidationTest < Minitest::Test
      def setup
        @visitor = Visitor.new('Gregory House', true)
        @visit   = Visit.new(@visitor, '31-05-2015')

        @validator = VisitValidator.new
      end

      def test_validate_returns_no_errors_if_visitor_has_ticket
        errors = @validator.validate(@visit)

        assert errors.empty?
      end

      def test_validate_returns_one_error_if_visitor_has_no_ticket
        @visitor.has_ticket = false
        errors = @validator.validate(@visit)

        assert_equal 1, errors.size
      end

      def test_validate_returns_error_with_correct_scope
        @visitor.has_ticket = false
        error = @validator.validate(@visit).first

        assert_equal [:visitor], error.scope
      end
    end
  end
end
