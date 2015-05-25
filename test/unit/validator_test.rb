require 'test_helper'

TestValidator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject    = OpenStruct.new(name: 'Gregory House')
      @validator  = TestValidator.new(@subject)
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

    def test_errors_is_empty_if_not_validated
      assert @validator.errors.empty?
    end

    def test_validate_calls_validate_on_group
      @mock_group.expect :validate, true, [@subject, @subject, []]

      @validator.validate([])
      @mock_group.verify
    end

    def test_valid_returns_true_if_there_are_no_errors
      @mock_group.expect :validate, true, [@subject, @subject, []]

      assert @validator.valid?
      @mock_group.verify
    end

    def test_valid_returns_false_if_validate_adds_errors
      @mock_group.expect :validate, true do |_value, _subject, errors|
        errors << Error.new(:error)
      end

      refute @validator.valid?
      @mock_group.verify
    end
  end
end
