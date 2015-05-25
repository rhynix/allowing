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
user.errors # => [#<Allowing::Error @name=:presence, @scope=[:name], @value=nil, @validation=...>]
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
user_validator.errors # => [#<Allowing::Error @name=:presence, @scope=[:company, :vat_number], @value=nil @validation=...>]
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

The argument for `with` can be any class that responds to the `validate` method. This method should take one argument and all errors for the validation will be added to this variable. The class should also `initialize` with the object that should be validated. For example:

```ruby
class EmailValidator
  def initialize(email)
    @email = email
  end 

  def validate(errors)
    errors << Error.new(:invalid_email, value: @email) unless @email =~ /@/
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
    unless subject.wheels == 4
      errors << Error.new(:incorrect_number, value: subject.wheels, scope: :wheels)
    end
  end
end

Car = Struct.new(wheels)
car = Car.new(3)

car_validator = CarValidator.new(car)

car_validator.valid? # => false
car_validator.errors # => [#<Allowing::Error @name=:incorrect_number, @scope=[:wheels], @value=3, @validation=...>]
```

## Validations on self

If no attributes are given, the validation is performed on self:

```ruby
class EmailValidator < Allowing::Validator
  validates format: /@/
end

EmailValidator.new('user@example.com').valid? # => true
```

## Validations

At this moment, the following types of validation are defined:

### Presence 

Checks whether the attribute is non-nil and non-empty. If the attribute is non-nil and does not respond to `empty?`, the object is always considered present.

###### Example

```ruby
validates :name, presence: true
```

### Format

Checks whether the attribute matches a regular expression. Calls `#to_s` on attribute before matching against the regular expression. Nil is considered invalid.

###### Example

```ruby
validates :email, format: /@/
```

### Size

Checks whether the attribute has a certain size. The rule can be both an exact number and a range. Because the `#cover?` method is used for ranges, minimum and maximum values are possible using Ruby's `Float::INFINITY`. See example for a minimum size. Nil is considered invalid, otherwise the attribute must respond to `#size`.

###### Example

```ruby
validates :bio, size: 100..Float::INFINITY
validates :registration_number, size: 10
```


### Inclusion

Checks wether the value is included in an array or range, or any other object responding to `#include?`.

###### Example

```ruby
validates :gender, inclusion: %w(Male Female)
```


### Exclusion

Checks whether the value is not included in an array or range, or any other object responding to `#include?`. This validation is the opposite of the inclusion validation.

###### Example

```ruby
validates :age, exclusion: 0..17
```

## Options

Validations can also take options about when to validate. Multiple options can be used on a single validation. At this moment, the following options are available:

### If

Validates only if the condition returns true. The supplied option can be a proc or lambda, or any other object that responds to `#call(subject)`.

###### Example

```ruby
validates :name, if: proc { |user| user.validate_name? }
```

### Unless

The opposite of the if-option, only validates if the condition returns false.

###### Example

```ruby
validates :name, unless: proc { |user| user.admin? }
```

### Allow nil

Only perform the validation if the attribute is not equal to nil. If the attribute is nil, no validation is performed and thus the attribute will be considered valid. This option can not be used on block validations, because block validations are not defined on an attribute.

###### Example

```ruby
validates :email, format: /@/, allow_nil: true
```
