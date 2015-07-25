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

      @validator = DoctorValidator.new
    end

    def test_validate_returns_no_errors_for_valid_subject
      assert_equal [], @validator.call(@doctor)
    end

    def test_validate_returns_correct_error_for_invalid_attribute
      @doctor.name = nil

      error = @validator.call(@doctor).first

      assert_equal :presence, error.name
      assert_equal [:name],   error.scope
      assert_equal nil,       error.value
    end

    def test_validate_returns_with_correct_scope_for_invalid_nested_attribute
      @hospital.name = nil

      error = @validator.call(@doctor).first

      assert_equal :presence,          error.name
      assert_equal [:hospital, :name], error.scope
      assert_equal nil,                error.value
    end

    def test_error_has_the_correct_scope_for_invalid_deep_nested_attribute
      @dean.name = nil

      error = @validator.call(@doctor).first

      assert_equal :presence,                 error.name
      assert_equal [:hospital, :dean, :name], error.scope
      assert_equal nil,                       error.value
    end
  end
end
