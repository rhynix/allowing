require 'test_helper'
require 'unit/wrappers/wrapper_test'

module Allowing
  module Wrappers
    class ConditionalWrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation
        @attribute  = :attribute

        @wrapper = ConditionalWrapper.new(@rule, @validation)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @wrapper.validate(:value, [], :subject)
        end
      end
    end
  end
end
