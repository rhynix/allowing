require 'test_helper'

module Allowing
  class WrapperBuilderTest < Minitest::Test
    def test_builds_a_if_wrapper
      validation = :validation
      rule = proc { |subject| subject.call? }
      wrapper = WrapperBuilder.new(:if, rule, validation).build

      assert wrapper.is_a?(Wrappers::IfWrapper)
      assert_equal rule, wrapper.rule
      assert_equal validation, wrapper.validation
    end

    def test_builds_an_unless_wrapper
      validation = :validation
      rule = proc { |subject| subject.call? }
      wrapper = WrapperBuilder.new(:unless, rule, validation).build

      assert wrapper.is_a?(Wrappers::UnlessWrapper)
      assert_equal rule, wrapper.rule
      assert_equal validation, wrapper.validation
    end

    def test_build_raises_for_unknown_wrapper
      assert_raises(UnknownWrapperError) do
        WrapperBuilder.new(:unknown, :rule, :validation).build
      end
    end
  end
end
