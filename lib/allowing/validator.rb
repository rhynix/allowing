require 'allowing/validations_group'
require 'allowing/dsl'

module Allowing
  class Validator
    extend DSL

    def self.group
      @group ||= ValidationsGroup.new
    end

    def self.group=(group)
      @group = group
    end

    def self.validations
      group.validations
    end

    def call(subject)
      group.call(subject, subject)
    end

    private

    def group
      self.class.group
    end
  end
end
