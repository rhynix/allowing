require 'test_helper'

module SimpleValidations
  module Wrappers
    class ConditionalWrapperTest < Minitest::Test
      def setup
        @wrapper = ConditionalWrapper.new(true, :validation)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @wrapper.call(:value)
        end
      end
    end
  end
end
