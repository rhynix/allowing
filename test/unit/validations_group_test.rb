require 'test_helper'

module Allowing
  class ValidationsGroupTest < Minitest::Test
    def setup
      @mock_validation = Minitest::Mock.new
      @group           = ValidationsGroup.new(:attribute, [@mock_validation])
      @subject         = OpenStruct.new(attribute: :value)
    end

    def test_validations_returns_empty_array_by_default
      assert_equal [], ValidationsGroup.new.validations
    end

    def test_sets_the_initial_validations
      assert_equal [@mock_validation], @group.validations
    end

    def test_test_the_attribute
      assert_equal :attribute, @group.attribute
    end

    def test_group_has_validations_manager_for_group
      assert @group.manager.kind_of?(ValidationsManager)
      assert_equal @group, @group.manager.group
    end

    def test_initialize_allows_adding_validations_in_block
      group = ValidationsGroup.new do
        validates :attribute, presence: true
      end

      assert_equal 1, group.validations.count
    end

    def test_validate_calls_validate_on_validations
      @mock_validation.expect :validate, true, [:value, []]
      @group.validate(@subject, [])

      @mock_validation.verify
    end

    def test_validate_adds_the_correct_scope_on_error
      errors = []
      @mock_validation.expect :validate, true do |subject, errors|
        errors << Error.new(:name, :nested_attribute)
      end

      @group.validate(@subject, errors)

      assert_equal [:attribute, :nested_attribute], errors.first.scope

      @mock_validation.verify
    end

    def test_validate_does_not_affect_scope_of_irrelevant_errors
      error = Error.new(:error)
      errors = [error]

      @mock_validation.expect :validate, true, [:value, []]

      @group.validate(@subject, errors)
      assert_equal [], error.scope
    end
  end
end
