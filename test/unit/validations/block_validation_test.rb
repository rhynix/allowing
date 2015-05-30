require 'test_helper'

module Allowing
  module Validations
    class BlockValidationTest < Minitest::Test
      def setup
        @error = Error.new(:error)

        @validation = BlockValidation.new do |value, subject|
          @value   = value
          @subject = subject

          [@error]
        end
      end

      def test_validate_calls_block_with_value
        @validation.validate(:value, :subject)

        assert_equal :value, @value
      end

      def test_validate_calls_block_with_subject
        @validation.validate(:value, :subject)

        assert_equal :subject, @subject
      end

      def test_validate_returns_the_errors
        errors = @validation.validate(:value, :subject)

        assert_equal [@error], errors
      end
    end
  end
end
