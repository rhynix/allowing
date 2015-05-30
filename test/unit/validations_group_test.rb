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

    def test_validate_delegates_to_all_validations
      @group.validations << Doubles::ErrorValidation.new(:error)
      @group.validations << Doubles::ValidValidation.new

      errors = @group.validate(:value)

      assert_equal [:error], errors.map(&:name)
    end
  end
end
