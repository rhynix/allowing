require 'test_helper'

TestValidator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject    = OpenStruct.new(name: 'Gregory House')
      @validator  = TestValidator.new
      @mock_dsl   = Minitest::Mock.new
      @validation = Doubles::ErrorValidation.new(:error)

      TestValidator.dsl   = @mock_dsl
      TestValidator.group = @validation
    end

    def test_validates_calls_validates_on_group
      @mock_dsl.expect :validates, true, [:attribute, { presence: true }]

      TestValidator.validates(:attribute, presence: true)

      @mock_dsl.verify
    end

    def test_validate_delegates_to_group
      errors = @validator.call(@subject)
      assert_equal [:error], errors.map(&:name)
    end
  end
end
