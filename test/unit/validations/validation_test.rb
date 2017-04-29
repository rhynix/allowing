require 'test_helper'

module SimpleValidations
  module Validations
    class ValidationTest < Minitest::Test
      def setup
        @validation = Validation.new(:rule)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @validation.call(:value)
        end
      end
    end
  end
end
