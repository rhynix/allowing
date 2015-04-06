require 'allowing/wrappers/conditional_wrapper'

module Allowing
  module Wrappers
    class AllowNilWrapper < ConditionalWrapper
      private

      def validate?(subject)
        !rule || !value_for(subject).nil?
      end

      def value_for(subject)
        subject.public_send(attribute)
      end
    end
  end
end
