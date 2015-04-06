require 'test_helper'

module Allowing
  module Wrappers
    module SharedWrapperTest
      def test_sets_the_rule
        assert_equal @rule, @wrapper.rule
      end

      def test_sets_the_validation
        assert_equal @validation, @wrapper.validation
      end
    end

    class WrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation

        @wrapper = Wrapper.new(@rule, @validation)
      end
    end
  end
end
