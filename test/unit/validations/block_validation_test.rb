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
        @validation.validate(:subject, :errors)

        assert_equal :errors, @errors
      end

      def test_calls_block_with_subject
        @validation.validate(:subject, :errors)

        assert_equal :subject, @subject
      end

      def test_attribute_returns_nil
        assert @validation.attribute.nil?
      end
    end
  end
end
