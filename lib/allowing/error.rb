class Error
  attr_reader :validation, :name, :value

  def initialize(name, value: nil, scope: nil, validation: nil)
    @name       = name
    @value      = value
    @validation = validation

    unshift_scope(scope) if scope
  end

  def scope
    @scope ||= []
  end

  def unshift_scope(new_scope)
    scope.unshift(new_scope) if new_scope
  end
end
