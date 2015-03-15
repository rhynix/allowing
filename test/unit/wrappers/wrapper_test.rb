require 'test_helper'

class DummyWrapper < Allowing::Wrappers::Wrapper
end

module Allowing
  module Wrappers
    class WrapperTest < Minitest::Test
      def test_wrappers_returns_array_of_inherited_classes
        assert_equal DummyWrapper, Wrapper.wrappers[:dummy]
      end
    end
  end
end
