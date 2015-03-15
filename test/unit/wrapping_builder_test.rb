require 'test_helper'

module Allowing
  class WrappingBuilderTest < Minitest::Test
    def setup
      wrappers = { if: :if_condition, unless: :unless_condition }

      @outer_wrapper = WrappingBuilder.new(:validation, wrappers).build
      @inner_wrapper = @outer_wrapper.validation
      @validation    = @inner_wrapper.validation
    end

    def test_build_returns_nested_wrappers_from_initialize_in_correct_order
      assert @outer_wrapper.is_a?(Wrappers::IfWrapper)
      assert @inner_wrapper.is_a?(Wrappers::UnlessWrapper)
      assert_equal :validation, @validation
    end

    def test_build_assings_rules_to_wrappers
      assert_equal :if_condition,     @outer_wrapper.rule
      assert_equal :unless_condition, @inner_wrapper.rule
    end
  end
end
