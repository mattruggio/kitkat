# frozen_string_literal: true

module Kitkat
  # Database-level operations.
  class Database
    def initialize(path)
      ensure_dir_exists(path)

      @connection = SQLite3::Database.new(path)

      load_schema

      freeze
    end

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

    attr_reader :connection

    def ensure_dir_exists(path)
      dir = File.dirname(path)

      FileUtils.mkdir_p(dir)
    end

    def sql_statement
      'INSERT OR IGNORE INTO files VALUES (?, ?, ?, ?, ?, ?, ?)'
    end

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
