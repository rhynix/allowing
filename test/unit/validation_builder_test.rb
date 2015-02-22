require 'test_helper'

module Allowing
  class ValidationBuilderTest < Minitest::Test
    def test_builds_a_presence_validation
      validation = ValidationBuilder.new(type: :presence,
                                         rule: true,
                                         attribute: :attribute).build

      assert validation.kind_of?(Validations::PresenceValidation)
      assert_equal true,       validation.rule
      assert_equal :attribute, validation.attribute
    end

    def test_builds_a_format_validation
      validation = ValidationBuilder.new(type: :format,
                                         rule: /Greg/,
                                         attribute: :attribute).build

      assert validation.kind_of?(Validations::FormatValidation)
      assert_equal /Greg/,     validation.rule
      assert_equal :attribute, validation.attribute
    end

    def test_raises_for_unknown_validation
      assert_raises(UnknownValidationError) do
        ValidationBuilder.new(type: :unknown,
                              rule: true,
                              attribute: :attribute).build
      end
    end
  end
end
