require 'test_helper'

Address = Struct.new(:street, :number)
User    = Struct.new(:name, :email, :address)

class EmailValidator
  def initialize(subject)
    @subject = subject
  end

  def validate(errors)
    errors << Error.new(:incorrect_email) unless @subject =~ /@/
  end
end

class AddressValidator < Allowing::Validator
  validates :street, presence: true
  validates :number, presence: true
end

class UserValidator < Allowing::Validator
  validates :email,   with: EmailValidator
  validates :address, with: AddressValidator
end

module IntegrationTests
  class WithValidationsTest < Minitest::Test
    def setup
      @address   = Address.new('Baker Street', '221B')
      @user      = User.new('Gregory House', 'greg@example.com', @address)
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

    def test_error_has_correct_name_and_scope_for_with_validation
      @user.email = 'gregexample.com'

      @validator.valid?
      assert_equal :incorrect_email, @validator.errors.first.name
      assert_equal [:email], @validator.errors.first.scope
    end
  end
end
