require 'test_helper'

module Allowing
  module Wrappers
    module SharedWrapperTest
    end

    class WrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation

        @wrapper = Wrapper.new(@rule, @validation)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @wrapper.validate(:value, [], :subject)
        end
      end
    end
  end
end
