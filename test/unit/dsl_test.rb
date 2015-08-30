require 'test_helper'
require 'allowing/dsl'

module Allowing
  class DSLTest < Minitest::Test
    def setup
      @capture = DSL::Capturer.new
    end

    def test_capture_returns_the_captured_validations
      validations = @capture.capture do
        validates presence: true
      end

      assert validations.first.is_a?(Validations::PresenceValidation)
    end
  end
end
