module Allowing
  module Helpers
    module ScopeHelpers
      def scope_errors(errors, scope)
        errors.each { |error| error.unshift_scope(scope) }
      end

      def with_scope(scope, parent_subject, errors)
        new_errors = []
        subject = scope ? parent_subject.send(scope) : parent_subject

        yield subject, new_errors

        scope_errors(new_errors, scope)
        errors.push(*new_errors)
      end
    end
  end
end
