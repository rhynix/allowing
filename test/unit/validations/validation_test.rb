require 'test_helper'

module Allowing
  module Validations
    class ValidationTest < Minitest::Test
      def setup
        @validation = Validation.new(:rule)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @validation.validate(:value, :subject)
        end
      end
    end
  end
end
