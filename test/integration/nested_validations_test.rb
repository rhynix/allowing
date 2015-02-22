require 'test_helper'

Doctor   = Struct.new(:name, :hospital)
Hospital = Struct.new(:name, :dean)
Dean     = Struct.new(:name)

class DoctorValidator < Allowing::Validator
  validates :name, presence: true

  validates :hospital do
    validates :name, presence: true

    validates :dean do
      validates :name, presence: true
    end
  end
end

module IntegrationTests
  class NestedValidationsTest < Minitest::Test
    def setup
      @dean     = Dean.new('Lisa Cuddy')
      @hospital = Hospital.new('Plainsboro', @dean)
      @doctor   = Doctor.new('Gregory House', @hospital)

      @validator = DoctorValidator.new(@doctor)
    end

    def test_valid_returns_true_for_invalid_subject
      assert @validator.valid?
    end

    def test_valid_returns_false_for_invalid_attribute
      @doctor.name = nil

      refute @validator.valid?
    end

    def test_error_has_the_correct_scope_for_invalid_attribute
      @doctor.name = nil

      @validator.valid?
      assert_equal [:name], @validator.errors.first.scope
    end

    def test_valid_returns_false_for_invalid_nested_attribute
      @hospital.name = nil

      refute @validator.valid?
    end

    def test_error_has_the_correct_scope_for_invalid_nested_attribute
      @hospital.name = nil

      @validator.valid?
      assert_equal [:hospital, :name], @validator.errors.first.scope
    end

    def test_valid_returns_false_for_invalid_deep_nested_attribute
      @dean.name = nil

      refute @validator.valid?
    end

    def test_error_has_the_correct_scope_for_invalid_deep_nested_attribute
      @dean.name = nil

      @validator.valid?
      assert_equal [:hospital, :dean, :name], @validator.errors.first.scope
    end
  end
end
