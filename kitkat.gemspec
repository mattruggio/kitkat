# frozen_string_literal: true

require './lib/kitkat/version'

Gem::Specification.new do |s|
  s.name        = 'kitkat'
  s.version     = Kitkat::VERSION
  s.summary     = 'File/Metadata Database Populator'

  s.description = <<-DESCRIPTION
    Small library that can populate a SQLite database with the recursive list of all files and their respective metadata.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mattruggio@icloud.com']
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'exe'
  s.executables = %w[kitkat]
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/mattruggio/kitkat'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/mattruggio/kitkat/issues',
    'changelog_uri' => 'https://github.com/mattruggio/kitkat/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/kitkat',
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }

  s.required_ruby_version = '>= 3.2.1'

  s.add_dependency('sorbet-runtime')
  s.add_dependency('sqlite3')

  s.add_development_dependency('bundler-audit')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('pry')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('rubocop-rake')
  s.add_development_dependency('rubocop-rspec')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('simplecov-console')
  s.add_development_dependency('sorbet')
  s.add_development_dependency('tapioca')
end
