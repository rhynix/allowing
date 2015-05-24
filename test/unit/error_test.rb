require 'test_helper'

module Allowing
  class ErrorTest < Minitest::Test
    def setup
      @validation = Validations::PresenceValidation.new(true)

      @name       = :error_name
      @value      = :value
      @error      = Error.new(@name, value: @value, validation: @validation)
    end

    def test_sets_the_validation
      assert_equal @validation, @error.validation
    end

    def test_sets_the_name
      assert_equal @name, @error.name
    end

    def test_sets_the_value
      assert_equal @value, @error.value
    end

    def test_allows_initial_scope_via_initialize
      error = Error.new(@name, scope: :initial_scope)
      assert_equal [:initial_scope], error.scope
    end

    def test_has_an_empty_scope_by_default
      assert @error.scope.empty?
    end

    def test_unshift_scope_scopes_the_error
      @error.unshift_scope :b
      @error.unshift_scope :a

      assert_equal [:a, :b], @error.scope
    end

    def test_unshift_scope_ignores_nil
      @error.unshift_scope nil

      assert @error.scope.empty?
    end
  end
end
