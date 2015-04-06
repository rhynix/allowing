require 'test_helper'

module Allowing
  module Validations
    class ValidationTest < Minitest::Test
      def setup
        @validation = Validation.new
      end

      def test_attribute_is_nil
        assert @validation.attribute.nil?
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @validation.validate(:subject, [])
        end
      end
    end
  end
end
