# Allowing

Allowing is a simple library to do validations on ordinary Ruby objects. A validator can be defined as follows:

```ruby
require 'allowing'

class UserValidator < Allowing::Validator
  validates :first_name, :last_name, presence: true
  validates :email, format: /@/
end
```

The validator can now be used as follows:

```ruby
User = Struct.new(:first_name, :last_name, :email)
user = User.new('Gregory', 'House', 'greg@example.com')

user_validator = UserValidator.new(user)

user.valid? # => true

user.name = nil

user.valid? # => false
user.errors # => [#<Allowing::Error @name=:presence, @scope=[:name], @validation=...>]
```

The `errors` method should be called after validating the object using `valid?`.

## Nested validations

Validations can also be nested to define validations on attributes of attributes:

```ruby
class UserValidator < Allowing::Validator
  validates :name, presence: true

  validates :company do
    validates :vat_number, presence: true
  end
end

User    = Struct.new(:name, :company)
Company = Struct.new(:name, :vat_number)

company = Company.new('Company', nil)
user    = User.new('User', company)

user_validator = UserValidator.new(user)

user_validator.valid? # => false
user_validator.errors # => [#<Allowing::Error @name=:presence, @scope=[:company, :vat_number], @validation=...>]
```

This same validator could also be defined in a more reusable way:

```ruby
class CompanyValidator < Allowing::Validator
  validates :vat_number, presence: true
end

class UserValidator < Allowing::Validator
  validates :name, presence: true
  validates :company, with: CompanyValidator
end
```

The argument for `with` can be any class that responds to the `validate` method. This method should take one argument and all errors for the validation should be added to this variable. The class should also `initialize` with the object that should be validated.

```ruby
class EmailValidator
  def initialize(email)
    @email = email
  end 

  def validate(errors)
    errors << Error.new(:invalid_email) unless @email =~ /@/
  end
end

class UserValidator < Allowing::Validator
  validates :name, presence: true
  validates :email, with: EmailValidator
end
```

## Block validations

Custom validations can also be defined inline using a block validation:

```ruby
class CarValidator < Allowing::Validator
  validates do |subject, errors|
    errors << Error.new(:incorrect_number_of_wheels) unless subject.wheels == 4
  end
end

Car = Struct.new(wheels)
car = Car.new(3)

car_validator = CarValidator.new(car)

car_validator.valid? # => false
car_validator.errors # => [#<Allowing::Error @name=:incorrect_number_of_wheels, @scope=[], @validation=...>]
```

## Validations

At this moment, there are only two validations defined:

1. `presence` checks wether the attribute is non-nil and non-empty
2. `format` checks wether the attribute matches a regular expression
