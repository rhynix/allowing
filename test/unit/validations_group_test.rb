require 'test_helper'

module Allowing
  class ValidationsGroupTest < Minitest::Test
    def setup
      @group = ValidationsGroup.new
    end

    def test_validations_returns_empty_array_by_default
      assert_equal [], @group.validations
    end

    def test_initialize_sets_validations
      group = ValidationsGroup.new([:validation])
      assert_equal [:validation], group.validations
    end

    def test_validate_calls_validate_on_validations
      mock_validation = Minitest::Mock.new
      mock_validation.expect :validate, true, [:value, :subject, []]

      @group.validations << mock_validation
      @group.validate(:value, :subject, [])

      mock_validation.verify
    end
  end
end
