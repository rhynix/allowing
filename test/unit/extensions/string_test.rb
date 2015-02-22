require 'test_helper'
require 'allowing/extensions/string'

module Allowing
  module Extensions
    class StringTest < Minitest::Test
      using Extensions::String

      def test_classify_returns_a_class_like_string
        assert_equal 'JustASimpleClass', 'just_a_simple_class'.classify
      end

      def test_underscore_returns_an_underscored_string
        assert_equal 'just_a_simple_class', 'JustASimpleClass'.underscore
      end
    end
  end
end
