require 'test_helper'

Address = Struct.new(:street, :number)
User    = Struct.new(:name, :email, :address, :password)

class EmailValidator < SimpleValidations::Validator
  def call(subject)
    if subject =~ /@/
      []
    else
      [SimpleValidations::Error.new(:incorrect_email, value: subject)]
    end
  end
end

class AuthenticatableValidator < SimpleValidations::Validator
  validates :password, presence: true
end

class AddressValidator < SimpleValidations::Validator
  validates :street, presence: true
  validates :number, presence: true
end

class UserValidator < SimpleValidations::Validator
  validates with: AuthenticatableValidator.new

  validates :name, with: lambda { |name|
    if name.strip.empty?
      [SimpleValidations::Error.new(:no_name, value: name)]
    else
      []
    end
  }

  validates :email,   with: EmailValidator.new
  validates :address, with: AddressValidator.new
end

module IntegrationTests
  class WithValidationsTest < Minitest::Test
    def setup
      @address   = Address.new('Baker Street', '221B')
      @subject   = User.new('Gregory House', 'greg@example.com', @address, 'q')

      @validator = UserValidator.new
    end

    def test_validate_returns_no_errors_for_valid_subject
      assert_equal [], @validator.call(@subject)
    end

    def test_validate_returns_correct_error_for_invalid_name
      @subject.name = ' '

      error = @validator.call(@subject).first

      assert_equal :no_name, error.name
      assert_equal [:name],  error.scope
      assert_equal ' ',      error.value
    end

    def test_validate_returns_correct_error_for_invalid_email
      @subject.email = 'greg'

      error = @validator.call(@subject).first

      assert_equal :incorrect_email, error.name
      assert_equal [:email],         error.scope
      assert_equal 'greg',           error.value
    end

    def test_validate_returns_correct_error_for_invalid_address
      @address.street = nil

      error = @validator.call(@subject).first

      assert_equal :presence,           error.name
      assert_equal [:address, :street], error.scope
      assert_nil   error.value
    end

    def test_validate_returns_correct_error_for_invalid_password
      @subject.password = nil

      error = @validator.call(@subject).first

      assert_equal :presence,   error.name
      assert_equal [:password], error.scope
      assert_nil   error.value
    end
  end
end
