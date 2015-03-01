require 'test_helper'

module Allowing
  class ValidationsManagerTest < Minitest::Test
    def setup
      @group   = ValidationsGroup.new
      @manager = ValidationsManager.new(@group)
    end

    def test_starts_with_no_validations
      assert_equal 0, @group.validations.count
    end

    def test_define_validations_can_add_validations_in_block
      @manager.define_validations do
        validates :attribute, presence: true
      end

      assert_equal 1, @group.validations.count
    end

    def test_adding_a_validation_creates_the_validation
      @manager.validates(:attribute, presence: true)

      assert_equal 1, @group.validations.count
    end

    def test_adding_a_validation_creates_the_right_validation
      @manager.validates(:attribute, presence: true)

      assert @group.validations.first.kind_of?(Validations::PresenceValidation)
    end

    def test_adding_nested_validations_adds_a_new_manager_validation
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert @group.validations.first.kind_of? ValidationsGroup
    end

    def test_adding_nested_validations_sets_the_attribute_on_the_validation
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert_equal :attribute, @group.validations.first.attribute
    end

    def test_adding_nested_validations_adds_a_validation_to_new_manager
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert_equal 1, @group.validations.first.validations.count
    end

    def test_naming_multiple_attributes_creates_validations_for_each_attribute
      @manager.validates :a, :b, presence: true, format: /[A-Z]/

      assert_equal 4, @group.validations.count
    end

    def test_naming_multiple_attributes_creates_nested_validations_for_each_attribute
      @manager.validates :a, :b do
        validates :attribute, presence: true
      end

      assert_equal 2, @group.validations.count

      @group.validations.each do |validation|
        assert_equal 1, validation.validations.count
      end
    end

    def test_raises_invalid_validation_error_if_no_validation_given
      assert_raises(IncompleteValidationError) do
        @manager.validates(:name)
     end
    end

    def test_validates_takes_no_arguments_with_block
      @manager.validates do
        'block'
      end
    end
  end
end
