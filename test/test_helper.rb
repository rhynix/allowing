if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
  end
end

require_relative '../lib/allowing'
require_relative 'support/doubles'

require 'minitest'
require 'minitest/autorun'
require 'minitest/rg'

require 'ostruct'
