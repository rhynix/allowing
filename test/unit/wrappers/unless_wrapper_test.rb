require 'test_helper'

module Allowing
  module Wrappers
    class UnlessWrapperTest < Minitest::Test
      def setup
        @validation = Doubles::ErrorValidation.new(:error)

        rule     = proc { |subject| subject.skip? }
        @wrapper = UnlessWrapper.new(rule, @validation)
      end

      def test_validate_returns_errors_from_validation_if_rule_returns_false
        subject = OpenStruct.new(skip?: false)
        errors  = @wrapper.call(:value, subject)

        assert_equal [:error], errors.map(&:name)
      end

      def test_validate_returns_no_errors_if_rule_returns_false
        subject = OpenStruct.new(skip?: true)
        errors  = @wrapper.call(:value, subject)

        assert errors.empty?
      end
    end
  end
end
