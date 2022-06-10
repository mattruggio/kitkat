# Kitkat

#### File/Metadata Database Populator

[![Gem Version](https://badge.fury.io/rb/kitkat.svg)](https://badge.fury.io/rb/kitkat) [![Ruby Gem CI](https://github.com/mattruggio/kitkat/actions/workflows/rubygem.yml/badge.svg)](https://github.com/mattruggio/kitkat/actions/workflows/rubygem.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/7d9a8642cf5bd88a550d/maintainability)](https://codeclimate.com/github/mattruggio/kitkat/maintainability) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

I had a need to recursively enumerate a directory and load the paths, and some metadata about the files, into a SQLite file.

## Installation

To install through Rubygems:

````
gem install kitkat
````

You can also add this to your Gemfile using:

````
bundle add kitkat
````

## Usage

### Executable

This library ships with an executable: `exe/kitkat`.  Simply run this from your shell:

````zsh
bundle exec kitkat <path> <database>
````

For Example: `bundle exec kitkat some_directory some_directory_contents.db`.  This will recursively scan the relative path at: `some_directory` and list all its contents in a SQLite database file relatively located at: `some_directory_contents.db`.

Notes:

* The database positional argument is optional.  If it is not supplied then it will default to: `kitkat.db`

### Ruby API

You can also include this gem and use directly through code:

```ruby
Kitkat.crawl(db: 'some_directory_contents.db', path: 'some_directory')
```

The Ruby code above is functionally equivalent to running the executable script above.

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check kitkat.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:mattruggio/kitkat.git)
4. Navigate to the root folder (cd kitkat)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````zsh
bin/rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````zsh
bin/guard
````

Also, do not forget to run Rubocop:

````zsh
bin/rubocop
````

And auditing the dependencies:

````zsh
bin/bundler-audit check --update
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into main
2. Update `version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push main to remote and ensure CI builds main successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mattruggio/kitkat/blob/main/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
