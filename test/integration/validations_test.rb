require 'test_helper'

Person = Struct.new(:first_name, :last_name)

class PersonValidator < Allowing::Validator
  validates :first_name, :last_name, presence: true
end

module IntegrationTests
  class ValidationsTest < Minitest::Test
    def setup
      @subject   = Person.new('Gregory', 'House')
      @validator = PersonValidator.new(@subject)
    end

    def test_valid_returns_true_for_a_valid_subject
      assert @validator.valid?
    end

    def test_errors_are_empty_for_a_valid_subject
      @validator.valid?

      assert @validator.errors.empty?
    end

    def test_valid_returns_false_for_an_invalid_subject
      @subject.first_name = nil

      refute @validator.valid?
    end

    def test_errors_returns_the_correct_error_name_and_scope_for_invalid_subject
      @subject.first_name = nil

      @validator.valid?
      assert_equal :presence, @validator.errors.first.name
      assert_equal [:first_name], @validator.errors.first.scope
    end
  end
end
