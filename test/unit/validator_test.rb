require 'test_helper'

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject         = OpenStruct.new(name: 'Gregory House')
      @validator_class = Class.new(Allowing::Validator)
      @validator       = @validator_class.new
      @validation      = Doubles::ErrorValidation.new(:error)
    end

    def test_validates_adds_a_validation
      @validator_class.validates presence: true

      validations = @validator_class.validations
      assert validations.first.is_a?(Validations::PresenceValidation)
    end

    def test_validate_delegates_to_group
      @validator_class.group = @validation

      errors = @validator.call(@subject)
      assert_equal [:error], errors.map(&:name)
    end
  end
end
