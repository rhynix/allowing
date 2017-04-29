require 'test_helper'

module SimpleValidations
  module Wrappers
    class WrapperTest < Minitest::Test
      def setup
        @wrapper = Wrapper.new(true, :validation)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @wrapper.call(:value)
        end
      end
    end
  end
end
