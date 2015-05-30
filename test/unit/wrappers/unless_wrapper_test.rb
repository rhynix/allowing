require 'test_helper'

module Allowing
  module Wrappers
    class UnlessWrapperTest < Minitest::Test
      def setup
        @validation = Doubles::ErrorValidation.new(:error)

        rule     = proc { |subject| subject.skip? }
        @wrapper = UnlessWrapper.new(rule, @validation)
      end

      def test_calls_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(skip?: false)
        errors  = @wrapper.validate(:value, subject)

        assert_equal [:error], errors.map(&:name)
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(skip?: true)
        errors  = @wrapper.validate(:value, subject)

        assert errors.empty?
      end
    end
  end
end
