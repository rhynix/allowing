require 'test_helper'
require 'simple_validations/wrappers'

SimpleValidations::Wrappers::DummyWrapper = Class.new

module SimpleValidations
  class WrappersTest < Minitest::Test
    def test_exists_returns_true_if_wrapper_class_exists
      assert Wrappers.exists?(:dummy)
    end

    def test_exists_returns_false_if_wrapper_class_does_not_exist
      refute Wrappers.exists?(:non_existing_wrapper)
    end

    def test_wrapper_class_name_returns_class_name
      assert_equal 'DummyWrapper', Wrappers.class_name(:dummy)
    end
  end
end
