require 'test_helper'
require 'simple_validations/wrappers/attributes_wrapper'

module SimpleValidations
  module Wrappers
    class AttributesWrapperTest < Minitest::Test
      def setup
        @subject    = OpenStruct.new(attr_a: :value_a, attr_b: :value_b)
        @validation = Doubles::ErrorValidation.new(:error)

        @wrapper = AttributesWrapper.new([:attr_a, :attr_b], @validation)
      end

      def test_validate_returns_errors_for_all_attributes
        errors = @wrapper.call(@subject)

        assert_equal 2, errors.size
      end

      def test_validate_returns_scoped_errors_from_validations
        errors = @wrapper.call(@subject)

        assert_equal [[:attr_a], [:attr_b]], errors.map(&:scope).sort
      end
    end
  end
end
