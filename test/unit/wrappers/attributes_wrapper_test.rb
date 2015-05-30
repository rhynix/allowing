require 'test_helper'
require 'allowing/wrappers/attributes_wrapper'

module Allowing
  module Wrappers
    class AttributesWrapperTest < Minitest::Test
      def setup
        @subject         = OpenStruct.new(attr_a: :value_a, attr_b: :value_b)
        @mock_validation = Minitest::Mock.new

        @wrapper = AttributesWrapper.new([:attr_a, :attr_b], @mock_validation)
      end

      def test_validate_delegates_to_validations_with_value_changed
        @mock_validation.expect :validate, [], [:value_a, :subject]
        @mock_validation.expect :validate, [], [:value_b, :subject]

        @wrapper.validate(@subject, :subject)

        @mock_validation.verify
      end

      def test_validate_returns_scoped_errors_from_validations
        error = Error.new(:presence)

        @mock_validation.expect :validate, [],      [:value_a, :subject]
        @mock_validation.expect :validate, [error], [:value_b, :subject]

        error = @wrapper.validate(@subject, :subject).first

        assert_equal [:attr_b], error.scope
      end
    end
  end
end
