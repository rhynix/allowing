require 'test_helper'

User = Struct.new(:name, :email)

class EmailValidator < Allowing::Validator
  def validate(subject, errors)
    errors << Error.new(:incorrect_email) unless subject =~ /@/
  end
end

class UserValidator < Allowing::Validator
  validates :email, with: EmailValidator
end

module IntegrationTests
  class WithValidationsTest < Minitest::Test
    def setup
      @user      = User.new('Gregory House', 'greg@example.com')
      @validator = UserValidator.new(@user)
    end

    def test_valid_returns_true_for_valid_subject
      assert @validator.valid?
    end

    def test_valid_returns_false_for_invalid_subject
      @user.email = 'gregexample.com'

      refute @validator.valid?
    end

    def test_error_has_correct_name_and_scope_for_with_validation
      @user.email = 'gregexample.com'

      @validator.valid?
      assert_equal :incorrect_email, @validator.errors.first.name
      assert_equal [:email], @validator.errors.first.scope
    end
  end
end
