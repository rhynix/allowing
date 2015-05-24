require 'test_helper'

module Allowing
  module Validations
    class BlockValidationTest < Minitest::Test
      def setup
        @validation = BlockValidation.new do |subject, errors|
          @errors = errors
          @subject = subject
        end
      end

      def test_calls_block_with_errors
        @validation.validate(:value, :errors, :subject)

        assert_equal :errors, @errors
      end

      def test_calls_block_with_subject
        @validation.validate(:value, :errors, :subject)

        assert_equal :value, @subject
      end
    end
  end
end
