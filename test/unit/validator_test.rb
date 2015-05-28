require 'test_helper'

TestValidator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject    = OpenStruct.new(name: 'Gregory House')
      @validator  = TestValidator.new
      @mock_dsl   = Minitest::Mock.new
      @mock_group = Minitest::Mock.new

      TestValidator.dsl   = @mock_dsl
      TestValidator.group = @mock_group
    end

    def test_validates_calls_validates_on_group
      @mock_dsl.expect :validates, true, [:attribute, { presence: true }]

      TestValidator.validates(:attribute, presence: true)

      @mock_dsl.verify
    end

    def test_validate_returns_errors_from_group
      @mock_group.expect :validate, true do |_, _, errors|
        errors << :error
      end

      errors = @validator.validate(@subject)

      assert_equal [:error], errors
      @mock_group.verify
    end
  end
end
