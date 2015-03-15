require 'allowing/wrappers/wrapper'

module Allowing
  module Wrappers
    class AllowNilWrapper < Wrapper
      def validate(subject, errors)
        validation.validate(subject, errors) if validate?(subject)
      end

      private

      def validate?(subject)
        !rule || !subject.nil?
      end
    end
  end
end
