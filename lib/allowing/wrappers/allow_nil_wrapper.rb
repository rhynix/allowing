require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class AllowNilWrapper < ConditionalWrapper
      private

      def validate?(subject)
        !rule || !subject.nil?
      end
    end
  end
end
