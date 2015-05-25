require 'test_helper'

module Allowing
  class AttributeValidationTest < Minitest::Test
    def test_builds_a_presence_validation
      validation = ValidationBuilder.new(:presence, true).build

      assert validation.is_a?(Validations::PresenceValidation)
      assert_equal true, validation.rule
    end

    def test_builds_a_format_validation
      validation = ValidationBuilder.new(:format, /Greg/).build

      assert validation.is_a?(Validations::FormatValidation)
      assert_equal(/Greg/, validation.rule)
    end

    def test_raises_for_unknown_validation
      assert_raises(UnknownValidationError) do
        ValidationBuilder.new(:unknown, true).build
      end
    end
  end
end
