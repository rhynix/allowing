require 'test_helper'

module Allowing
  module Wrappers
    class WrapperTest < Minitest::Test
      def setup
        @wrapper = Wrapper.new(true, :validation)
      end

      def test_sets_the_rule
        assert_equal true, @wrapper.rule
      end

      def test_sets_the_validation
        assert_equal :validation, @wrapper.validation
      end
    end
  end
end
