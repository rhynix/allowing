module Allowing
  module Validations
    class Validation
      def attribute
        nil
      end

      def validate(_subject, _errors)
        fail NotImplementedError, 'Should be implemented by subclass'
      end
    end
  end
end
