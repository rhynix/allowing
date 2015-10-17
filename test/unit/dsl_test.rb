require 'test_helper'
require 'allowing/dsl'

module Allowing
  class DSLTest < Minitest::Test
    def test_capture_returns_the_captured_validations
      validations = DSL.capture do
        validates presence: true
      end

      assert validations.first.is_a?(Validations::PresenceValidation)
    end
  end
end
