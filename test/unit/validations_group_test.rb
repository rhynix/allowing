require 'test_helper'

module Allowing
  class ValidationsGroupTest < Minitest::Test
    def setup
      @group = ValidationsGroup.new

      @group.builder_class = Doubles::ValidationsBuilder
    end

    def test_validations_returns_empty_array_by_default
      assert_equal [], @group.validations
    end

    def test_builder_class_is_validations_builder_by_default
      @group.builder_class = nil

      assert_equal ValidationsBuilder, @group.builder_class
    end

    def test_validates_adds_the_validations_created_by_builder
      @group.validates(presence: true)
      validation = @group.validations.first

      assert validation.is_a?(Validations::PresenceValidation)
    end

    def test_initialize_allows_adding_validations_via_block
      group = ValidationsGroup.new do
        validates :attribute, presence: true
      end

      validation = group.validations.first
      assert validation.is_a?(Wrappers::AttributesWrapper)
    end

    def test_validate_calls_validate_on_validations
      mock_validation = Minitest::Mock.new
      mock_validation.expect :validate, true, [:value, [], :subject]

      @group.validations << mock_validation
      @group.validate(:value, [], :subject)

      mock_validation.verify
    end
  end
end
