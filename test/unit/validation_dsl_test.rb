require 'test_helper'
require 'allowing/validation_dsl'

module Allowing
  class ValidationDSLTest < Minitest::Test
    def setup
      @validations = []

      @builder = Doubles::ValidationsBuilder
      @dsl     = ValidationDSL.new(@validations, @builder)
    end

    def test_builder_class_is_validations_builder_by_default
      dsl = ValidationDSL.new(@validations)
      assert_equal ValidationsBuilder, dsl.builder_class
    end

    def test_validates_adds_validation_created_by_builder
      @dsl.validates(presence: true)

      assert @validations.first.is_a?(Validations::PresenceValidation)
    end

    def test_define_returns_validations_added_in_block
      validations = ValidationDSL.define(@builder) do
        validates presence: true
      end

      assert validations.first.is_a?(Validations::PresenceValidation)
    end
  end
end
