require 'test_helper'

Manufacturer = Struct.new(:name)
Car          = Struct.new(:wheels, :manufacturer)

CAR_MANUFACTURERS = %w(Volkswagen Ford Fiat)

class CarValidator < Allowing::Validator
  validates do |car|
    if car.wheels == 4
      []
    else
      [Allowing::Error.new(
        :incorrect_number,
        value: car.wheels,
        scope: :wheels
      )]
    end
  end

  validates :manufacturer do
    validates do |manufacturer|
      if CAR_MANUFACTURERS.include? manufacturer.name
        []
      else
        [Allowing::Error.new(
          :no_manufacturer,
          value: manufacturer.name,
          scope: :name
        )]
      end
    end
  end
end

module IntegrationTests
  class BlockValidationsTest < Minitest::Test
    def setup
      @manufacturer = Manufacturer.new('Volkswagen')
      @car          = Car.new(4, @manufacturer)

      @validator = CarValidator.new
    end

    def test_validate_returns_no_errors_for_valid_subject
      errors = @validator.validate(@car)
      assert errors.empty?
    end

    def test_validate_returns_correct_error_for_block_validation
      @car.wheels = 3

      error = @validator.validate(@car).first

      assert_equal :incorrect_number, error.name
      assert_equal nil,               error.validation
      assert_equal [:wheels],         error.scope
      assert_equal 3,                 error.value
    end

    def test_validate_returns_correct_error_for_nested_block_validation
      @manufacturer.name = 'Apple'

      error = @validator.validate(@car).first

      assert_equal :no_manufacturer,       error.name
      assert_equal nil,                    error.validation
      assert_equal [:manufacturer, :name], error.scope
      assert_equal 'Apple',                error.value
    end
  end
end
