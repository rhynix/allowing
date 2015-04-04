require 'test_helper'

TestValidator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject    = OpenStruct.new(name: 'Gregory House')
      @validator  = TestValidator.new(@subject)
      @mock_group = Minitest::Mock.new

      TestValidator.group = @mock_group
    end

    def test_validates_calls_validates_on_group
      @mock_group.expect :validates, true, [:attribute, { presence: true }]

      TestValidator.validates(:attribute, presence: true)

      @mock_group.verify
    end

    def test_errors_is_empty_if_not_validated
      assert @validator.errors.empty?
    end

    def test_validate_calls_validate_on_group
      @mock_group.expect :validate, true, [@subject, []]

      @validator.validate([])
      @mock_group.verify
    end

    def test_valid_returns_true_if_there_are_no_errors
      @mock_group.expect :validate, true, [@subject, []]
      assert @validator.valid?
    end

    def test_valid_returns_false_if_validate_adds_errors
      @mock_group.expect :validate, true do |_subject, errors|
        errors << Error.new(:error, nil)
      end

      refute @validator.valid?
    end
  end
end
