require 'test_helper'

Address = Struct.new(:street, :number)
User    = Struct.new(:name, :email, :address, :password)

class EmailValidator < Allowing::Validator
  def validate(subject)
    return if subject =~ /@/

    [Error.new(:incorrect_email, value: subject)]
  end
end

class AuthenticatableValidator < Allowing::Validator
  validates :password, presence: true
end

class AddressValidator < Allowing::Validator
  validates :street, presence: true
  validates :number, presence: true
end

class UserValidator < Allowing::Validator
  validates with: AuthenticatableValidator

  validates :email,   with: EmailValidator
  validates :address, with: AddressValidator
end

module IntegrationTests
  class WithValidationsTest < Minitest::Test
    def setup
      @address   = Address.new('Baker Street', '221B')
      @subject   = User.new('Gregory House', 'greg@example.com', @address, 'q')

      @validator = UserValidator.new
    end

    def test_validate_returns_no_errors_for_valid_subject
      assert_equal [], @validator.validate(@subject)
    end

    def test_validate_returns_correct_error_for_invalid_email
      @subject.email = 'greg'

      error = @validator.validate(@subject).first

      assert_equal :incorrect_email, error.name
      assert_equal [:email],         error.scope
      assert_equal 'greg',           error.value
    end

    def test_validate_returns_correct_error_for_invalid_address
      @address.street = nil

      error = @validator.validate(@subject).first

      assert_equal :presence,           error.name
      assert_equal [:address, :street], error.scope
      assert_equal nil,                 error.value
    end

    def test_validate_returns_correct_error_for_invalid_password
      @subject.password = nil

      error = @validator.validate(@subject).first

      assert_equal :presence,   error.name
      assert_equal [:password], error.scope
      assert_equal nil,         error.value
    end
  end
end
