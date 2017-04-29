require 'test_helper'

module SimpleValidations
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

    def test_scoped_returns_error_with_new_scope
      scoped_error_a = @error.scoped(:a)
      scoped_error_b = scoped_error_a.scoped(:b)

      assert_equal [:b, :a], scoped_error_b.scope
    end

    def test_scoped_does_not_edit_own_scope
      @error.scoped(:scope)

      assert @error.scope.empty?
    end
  end
end
