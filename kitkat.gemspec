# frozen_string_literal: true

require './lib/kitkat/version'

Gem::Specification.new do |s|
  s.name        = 'kitkat'
  s.version     = Kitkat::VERSION
  s.summary     = 'Load up a SQLite file with the contents of a directory.'

  s.description = <<-DESCRIPTION
    Small library that can populate a SQLite database with the list of all files and sub-directories.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mattruggio@icloud.com']
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'exe'
  s.executables = %w[kitkat]
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.6'

  s.add_dependency('sqlite3')

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 13')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rubocop', '~>0.90.0')
  s.add_development_dependency('simplecov', '~>0.18.5')
  s.add_development_dependency('simplecov-console', '~>0.7.0')
end
