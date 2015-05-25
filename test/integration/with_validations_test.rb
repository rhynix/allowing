require 'test_helper'

Address = Struct.new(:street, :number)
User    = Struct.new(:name, :email, :address, :password)

class EmailValidator < Allowing::Validator
  def initialize(subject)
    @subject = subject
  end

  def validate(errors)
    return if @subject =~ /@/

    errors << Error.new(:incorrect_email, value: @subject)
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
      @user      = User.new('Gregory House', 'greg@example.com', @address, 'q')
      @validator = UserValidator.new(@user)
    end

    def test_valid_returns_true_for_valid_subject
      assert @validator.valid?
    end

    def test_valid_returns_false_for_invalid_email
      @user.email = 'greg'

      refute @validator.valid?
    end

    def test_valid_adds_correctly_scoped_error_for_invalid_email
      @user.email = 'greg'

      @validator.valid?
      assert_equal [:email], @validator.errors.first.scope
    end

    def test_valid_returns_false_for_invalid_address
      @address.street = nil

      refute @validator.valid?
    end

    def test_valid_adds_correctly_scoped_error_for_invalid_address
      @address.street = nil

      @validator.valid?
      assert_equal [:address, :street], @validator.errors.first.scope
    end

    def test_valid_returns_false_for_invalid_password
      @user.password = nil

      refute @validator.valid?
    end

    def test_valid_adds_correct_scoped_error_for_invalid_password
      @user.password = nil

      @validator.valid?
      assert_equal [:password], @validator.errors.first.scope
    end

    def test_error_is_correct_for_with_validation
      @user.email = 'greg'

      @validator.valid?
      error = @validator.errors.first

      assert_equal :incorrect_email, error.name
      assert_equal [:email],         error.scope
      assert_equal 'greg',           error.value
    end
  end
end
