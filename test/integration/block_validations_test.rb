require 'test_helper'

Manufacturer = Struct.new(:name)
Car          = Struct.new(:wheels, :manufacturer)

CAR_MANUFACTURERS = ['Volkswagen', 'Ford', 'Fiat']

class CarValidator < Allowing::Validator
  validates do |car, errors|
    errors << Error.new(:incorrect_number_of_wheels) if car.wheels != 4
  end

  validates :manufacturer do
    validates do |manufacturer, errors|
      unless CAR_MANUFACTURERS.include? manufacturer.name
        errors << Error.new(:no_car_manufacturer)
      end
    end
  end
end

module IntegrationTests
  class BlockValidationsTest < Minitest::Test
    def setup
      @manufacturer = Manufacturer.new('Volkswagen')
      @car          = Car.new(4, @manufacturer)

      @validator = CarValidator.new(@car)
    end

    def test_valid_returns_true_for_valid_subject
      assert @validator.valid?
    end

    def test_valid_returns_false_for_invalid_block_validation
      @car.wheels = 3

      refute @validator.valid?
    end

    def test_error_has_the_correct_name_and_scope_for_invalid_block_validation
      @car.wheels = 3

      @validator.valid?
      assert_equal :incorrect_number_of_wheels, @validator.errors.first.name
      assert_equal [], @validator.errors.first.scope
    end

    def test_valid_returns_false_for_invalid_nested_block_validation
      @manufacturer.name = 'Apple'

      refute @validator.valid?
    end

    def test_error_has_the_correct_name_and_scope_for_invalid_nested_block_validation
      @manufacturer.name = 'Apple'

      @validator.valid?
      assert_equal :no_car_manufacturer, @validator.errors.first.name
      assert_equal [:manufacturer], @validator.errors.first.scope
    end
  end
end
