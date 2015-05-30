module Allowing
  class Error
    attr_reader :validation, :name, :value, :scope

    def initialize(name, value: nil, scope: nil, validation: nil)
      @name       = name
      @value      = value
      @validation = validation
      @scope      = Array(scope)
    end

    def scoped(scope_to_add)
      new_scope = scope.dup.unshift(scope_to_add)

      Error.new(name, value: value, scope: new_scope, validation: validation)
    end
  end
end
