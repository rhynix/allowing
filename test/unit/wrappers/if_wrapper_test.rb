require 'test_helper'

module Allowing
  module Wrappers
    class IfWrapperTest < Minitest::Test
      def setup
        @validation = Doubles::ErrorValidation.new(:error)

        rule     = proc { |subject| subject.validate? }
        @wrapper = IfWrapper.new(rule, @validation)
      end

      def test_validate_returns_errors_from_validation_if_rule_returns_true
        subject = OpenStruct.new(validate?: true)
        errors  = @wrapper.validate(:value, subject)

        assert_equal [:error], errors.map(&:name)
      end

      def test_does_not_call_validate_on_validation_if_rule_returns_false
        subject = OpenStruct.new(validate?: false)
        errors  = @wrapper.validate(:value, subject)

        assert errors.empty?
      end
    end
  end
end
