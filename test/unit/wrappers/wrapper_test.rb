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

      def test_sets_the_attribute
        assert_equal @attribute, @wrapper.attribute
      end
    end

    class WrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @rule       = true
        @validation = :validation
        @attribute  = :attribute

        @wrapper = Wrapper.new(@rule, @validation, @attribute)
      end

      def test_validate_raises_error
        assert_raises(NotImplementedError) do
          @wrapper.validate(:subject, [])
        end
      end
    end
  end
end
