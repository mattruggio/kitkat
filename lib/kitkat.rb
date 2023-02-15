# frozen_string_literal: true

require 'digest'
require 'set'
require 'sqlite3'

require_relative 'kitkat/database'
require_relative 'kitkat/reader'

# Main example/easiest entry-point for this application.
module Kitkat
  class << self
    def crawl(path:, db:, io: $stdout)
      reader = Reader.new(path)
      db     = Database.new(db)

      reader.each.with_index(1) do |file_info, index|
        io.puts("[#{index}] #{file_info.relative_path}")

        db.insert(file_info)
      end

      io.puts('Complete')
    end
  end
end
