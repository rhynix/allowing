require 'test_helper'

TestValidator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject         = OpenStruct.new(name: 'Gregory House')
      @validator       = TestValidator.new
      @mock_dsl        = Minitest::Mock.new
      @mock_validation = Minitest::Mock.new

      TestValidator.dsl   = @mock_dsl
      TestValidator.group = @mock_validation
    end

    def test_validates_calls_validates_on_group
      @mock_dsl.expect :validates, true, [:attribute, { presence: true }]

      TestValidator.validates(:attribute, presence: true)

      @mock_dsl.verify
    end

    def test_validate_delegates_to_group
      options = { subject: :subject, validator: @validator }
      @mock_validation.expect :validate, [], [:subject, options]

      @validator.validate(:subject)

      @mock_validation.verify
    end
  end
end
