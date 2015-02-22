require 'test_helper'

Validator = Class.new(Allowing::Validator)

module Allowing
  class ValidatorTest < Minitest::Test
    def setup
      @subject         = OpenStruct.new(name: 'Gregory House')
      @validator       = Validator.new(@subject)
      @mock_validation = Minitest::Mock.new

      Validator.manager_validation = @mock_validation
    end

    def test_allows_injecting_a_validations_manager
      Validator.manager = :manager
      assert_equal :manager, Validator.manager

      Validator.manager = nil
    end

    def test_errors_is_empty_if_not_validated
      assert @validator.errors.empty?
    end

    def test_validate_calls_validate_on_manager_validation
      @mock_validation.expect :validate, true, [@subject, []]

      @validator.validate(@subject, [])
      @mock_validation.verify
    end

    def test_valid_returns_true_if_there_are_no_errors
      @mock_validation.expect :validate, true, [@subject, []]
      assert @validator.valid?
    end

    def test_valid_returns_false_if_validate_adds_errors
      @mock_validation.expect :validate, true do |subject, errors|
        errors << Error.new(:error, nil)
      end

      refute @validator.valid?
    end
  end
end
