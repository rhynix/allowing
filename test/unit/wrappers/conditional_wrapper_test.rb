require 'test_helper'

module Allowing
  module Wrappers
    class ConditionalWrapperTest < Minitest::Test
      def test_validate_raises_error
        wrapper = ConditionalWrapper.new(:rule, :validation)

        assert_raises(NotImplementedError) do
          wrapper.validate(:subject, [])
        end
      end
    end
  end
end
