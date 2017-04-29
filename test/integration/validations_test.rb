require 'test_helper'

Person = Struct.new(
  :first_name,
  :last_name,
  :doctor,
  :email,
  :bio,
  :age
)

class PersonValidator < SimpleValidations::Validator
  validates :first_name, :last_name, presence: true
  validates :doctor, inclusion: [true, false]
  validates :email, format: /@/
  validates :bio, size: 0..500
  validates :age, exclusion: 0..17
end

module IntegrationTests
  class ValidationsTest < Minitest::Test
    def setup
      @subject = Person.new(
        'Gregory',
        'House',
        true,
        'greg@example.com',
        'A doctor at Princeton-Plainsboro Teaching Hospital',
        40
      )

      @validator = PersonValidator.new
    end

    def test_validate_returns_no_errors_for_a_valid_subject
      assert_equal [], @validator.call(@subject)
    end

    def test_validate_returns_the_correct_error_for_invalid_subject
      @subject.first_name = nil

      errors = @validator.call(@subject)

      assert_equal :presence,     errors.first.name
      assert_equal [:first_name], errors.first.scope
    end
  end
end
