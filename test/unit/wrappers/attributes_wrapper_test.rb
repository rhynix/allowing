require 'test_helper'
require 'allowing/wrappers/attributes_wrapper'

require 'unit/wrappers/wrapper_test'

module Allowing
  module Wrappers
    class AttributesWrapperTest < Minitest::Test
      include SharedWrapperTest

      def setup
        @subject    = OpenStruct.new(attr_a: :value_a, attr_b: :value_b)
        @validation = Minitest::Mock.new
        @wrapper    = AttributesWrapper.new([:attr_a, :attr_b], @validation)

        @errors = []
      end

      def test_validate_delegates_to_validations_with_value_changed
        @validation.expect :validate, true, [:value_a, @errors, :subject]
        @validation.expect :validate, true, [:value_b, @errors, :subject]

        @wrapper.validate(@subject, @errors, :subject)

        @validation.verify
      end

      def test_validate_adds_scope_to_errors
        2.times do
          @validation.expect :validate, true do |value, errors|
            errors << Error.new(:presence) if value == :value_b

            true
          end
        end

        @wrapper.validate(@subject, @errors, :subject)

        assert_equal [:attr_b], @errors.first.scope
      end
    end
  end
end
