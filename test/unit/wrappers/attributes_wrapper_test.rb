require 'test_helper'
require 'allowing/wrappers/attributes_wrapper'

module Allowing
  module Wrappers
    class AttributesWrapperTest < Minitest::Test
      def setup
        @subject         = OpenStruct.new(attr_a: :value_a, attr_b: :value_b)
        @mock_validation = Minitest::Mock.new
        @errors          = []

        @wrapper = AttributesWrapper.new([:attr_a, :attr_b], @mock_validation)
      end

      def test_validate_delegates_to_validations_with_value_changed
        @mock_validation.expect :validate, true, [:value_a, :subject, @errors]
        @mock_validation.expect :validate, true, [:value_b, :subject, @errors]

        @wrapper.validate(@subject, :subject, @errors)

        @mock_validation.verify
      end

      def test_validate_adds_scope_to_errors
        2.times do
          @mock_validation.expect :validate, true do |value, _subject, errors|
            errors << Error.new(:presence) if value == :value_b

            true
          end
        end

        @wrapper.validate(@subject, :subject, @errors)

        assert_equal [:attr_b], @errors.first.scope
      end
    end
  end
end
