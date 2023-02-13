# frozen_string_literal: true
# typed: strict

module Kitkat
  # Database-level operations.
  class Database
    extend T::Sig

    sig { params(path: T.untyped).void }
    def initialize(path)
      ensure_dir_exists(path)

      @connection = T.let(SQLite3::Database.new(path), SQLite3::Database)

      load_schema

      freeze
    end

    sig { params(file_info: Kitkat::FileInfo).returns(Kitkat::Database) }
    def insert(file_info)
      connection.execute(
        sql_statement,
        file_info.relative_path,
        file_info.mime_type,
        file_info.mime_subtype,
        file_info.bytesize,
        file_info.last_modified_at.to_s,
        file_info.digest,
        Time.now.utc.to_s
      )

      self
    end

    private

    sig { returns(SQLite3::Database) }
    attr_reader :connection

    sig { params(path: T.any(String, Pathname)).returns(T::Array[String]) }
    def ensure_dir_exists(path)
      dir = File.dirname(path)

      FileUtils.mkdir_p(dir)
    end

    sig { returns(String) }
    def sql_statement
      'INSERT OR IGNORE INTO files VALUES (?, ?, ?, ?, ?, ?, ?)'
    end

    sig { void }
    def load_schema
      connection.execute <<-SQL
        CREATE TABLE IF NOT EXISTS files (
          path varchar NOT NULL,
          mime_type varchar NOT NULL,
          mime_subtype varchar NOT NULL,
          bytesize integer NOT NULL,
          last_modified_at datetime,
          digest varchar NOT NULL,
          created_at datetime NOT NULL
        );
      SQL

      connection.execute <<-SQL
        CREATE UNIQUE INDEX IF NOT EXISTS idx_files_path ON files (path);
      SQL
    end
  end
end
