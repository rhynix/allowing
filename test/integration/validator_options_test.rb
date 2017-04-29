require 'test_helper'

Owner      = Struct.new(:name)
Restaurant = Struct.new(:name, :open)

class RestaurantValidator < SimpleValidations::Validator
  validates :name, presence: true
  validates :owner, presence: true

  validates :owner, allow_nil: true do
    validates :name, presence: true
  end
end

class HashValidator < SimpleValidations::Validator
  validates :key, presence: true

  def default_options
    { attribute_strategy: :symbol_key }
  end
end

module SimpleValidations
  module IntegrationTests
    class ValidatorOptionsTest < Minitest::Test
      def test_validate_attribute_strategy_symbol_key_valid
        owner     = { name: 'Gustavo Fring' }
        subject   = { name: 'Los Pollos Hermanos', owner: owner }
        validator = RestaurantValidator.new(attribute_strategy: :symbol_key)

        assert validator.call(subject).empty?
      end

      def test_validate_attribute_strategy_symbol_key_shallow_error
        owner     = { name: 'Gustavo Fring' }
        subject   = { name: nil, owner: owner }
        validator = RestaurantValidator.new(attribute_strategy: :symbol_key)
        errors    = validator.call(subject)

        assert_equal [[:name]], errors.map(&:scope)
      end

      def test_validate_attribute_strategy_symbol_key_deep_error
        owner     = { name: nil }
        subject   = { name: 'Los Pollos Hermanos', owner: owner }
        validator = RestaurantValidator.new(attribute_strategy: :symbol_key)
        errors    = validator.call(subject)

        assert_equal [[:owner, :name]], errors.map(&:scope)
      end

      def test_validate_attribute_strategy_string_key_valid
        owner     = { 'name' => 'Gustavo Fring' }
        subject   = { 'name' => 'Los Pollos Hermanos', 'owner' => owner }
        validator = RestaurantValidator.new(attribute_strategy: :string_key)

        assert validator.call(subject).empty?
      end

      def test_validate_attribute_strategy_string_key_shallow_error
        owner     = { 'name' => 'Gustavo Fring' }
        subject   = { 'name' => nil, 'owner' => owner }
        validator = RestaurantValidator.new(attribute_strategy: :string_key)
        errors    = validator.call(subject)

        assert_equal [[:name]], errors.map(&:scope)
      end

      def test_validate_attribute_strategy_string_key_deep_error
        owner     = { 'name' => nil }
        subject   = { 'name' => 'Los Pollos Hermanos', 'owner' => owner }
        validator = RestaurantValidator.new(attribute_strategy: :string_key)
        errors    = validator.call(subject)

        assert_equal [[:owner, :name]], errors.map(&:scope)
      end

      def test_validate_attribute_with_default_strategy_no_error
        subject   = { key: 'Value' }
        validator = HashValidator.new

        assert validator.call(subject).empty?
      end

      def test_validate_attribute_with_default_strategy_shallow_error
        subject   = { key: nil }
        validator = HashValidator.new
        errors    = validator.call(subject)

        assert_equal [[:key]], errors.map(&:scope)
      end
    end
  end
end
