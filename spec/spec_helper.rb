# frozen_string_literal: true

require 'pry'
require 'securerandom'
require 'stringio'

unless ENV['DISABLE_SIMPLECOV'] == 'true'
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.formatter = SimpleCov::Formatter::Console
  SimpleCov.start do
    add_filter %r{\A/spec/}
  end
end

def fixture(*path)
  File.join('spec', 'fixtures', *path)
end

require 'rspec/expectations'
require './lib/kitkat'
