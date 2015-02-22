require 'test_helper'
require 'allowing/helpers/scope_helpers'

class WithScopeHelpers
  include Allowing::Helpers::ScopeHelpers
end

module Allowing
  module Helpers
    class ScopeHelpersTest < Minitest::Test
      def setup
        @object  = WithScopeHelpers.new
        @subject = OpenStruct.new(attribute: :value)

        @error  = Error.new(:error)
        @errors = [@error]
      end

      def test_with_scope_sends_to_the_subject_and_gives_value
        @object.with_scope(:attribute, @subject, @errors) do |subject, errors|
          assert_equal :value, subject
        end
      end

      def test_with_scope_sets_scope_on_added_errors
        new_error = Error.new(:new_error)
        @object.with_scope(:attribute, @subject, @errors) do |subject, errors|
          errors << new_error
        end

        assert_equal [], @error.scope
        assert_equal [:attribute], new_error.scope
      end

      def test_with_scope_does_not_add_nil_scope_to_errors
        new_error = Error.new(:new_error)
        @object.with_scope(nil, @subject, @errors) do |subject, errors|
          errors << new_error
        end

        assert_equal [], new_error.scope
      end

      def test_with_scope_gives_parent_object_for_nil_scope
        @object.with_scope(nil, @subject, @errors) do |subject, errors|
          assert_equal @subject, subject
        end
      end
    end
  end
end
