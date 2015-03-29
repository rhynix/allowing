require 'test_helper'

module Allowing
  class ValidationBuilderTest < Minitest::Test
    def test_builds_a_presence_validation
      validation = ValidationBuilder.new(:presence,
                                         true,
                                         :attribute).build

      assert validation.is_a?(Validations::PresenceValidation)
      assert_equal true,       validation.rule
      assert_equal :attribute, validation.attribute
    end

    def test_builds_a_format_validation
      validation = ValidationBuilder.new(:format,
                                         /Greg/,
                                         :attribute).build

      assert validation.is_a?(Validations::FormatValidation)
      assert_equal(/Greg/,     validation.rule)
      assert_equal :attribute, validation.attribute
    end

    def test_raises_for_unknown_validation
      assert_raises(UnknownValidationError) do
        ValidationBuilder.new(:unknown,
                              true,
                              :attribute).build
      end
    end
  end
end
