class Error
  attr_reader :validation, :name

  def initialize(name, initial_scope = nil, validation = nil)
    @validation = validation
    @name = name
    unshift_scope(initial_scope) if initial_scope
  end

  def scope
    @scope ||= []
  end

  def unshift_scope(new_scope)
    scope.unshift(new_scope) if new_scope
  end
end
