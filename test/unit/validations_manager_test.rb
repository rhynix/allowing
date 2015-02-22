require 'test_helper'

module Allowing
  class ValidationsManagerTest < Minitest::Test
    def setup
      @manager = Allowing::ValidationsManager.new
    end

    def test_starts_with_no_validations
      assert_equal 0, @manager.validations.count
    end

    def test_adding_a_validation_creates_the_validation
      @manager.validates(:attribute, presence: true)

      assert_equal 1, @manager.validations.count
    end

    def test_adding_a_validation_creates_the_right_validation
      @manager.validates(:attribute, presence: true)

      assert @manager.validations.first.kind_of?(Validations::PresenceValidation)
    end

    def test_adding_nested_validations_adds_a_new_manager_validation
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert @manager.validations.first.kind_of? Validations::ManagerValidation
    end

    def test_adding_nested_validations_sets_the_attribute_on_the_validation
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert_equal :attribute, @manager.validations.first.attribute
    end

    def test_adding_nested_validations_adds_a_validation_to_new_manager
      @manager.validates :attribute do
        validates :nested_attribute, presence: true
      end

      assert_equal 1, @manager.validations.first.manager.validations.count
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
