require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class AllowNilWrapper < ConditionalWrapper
      private

      def validate?(value, _subject)
        !rule || !value.nil?
      end
    end
  end
end
