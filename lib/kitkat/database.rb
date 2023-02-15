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
      insert_file(file_info)
      insert_content(file_info) if file_info.storable?

      self
    end

    private

    attr_reader :connection

    def insert_file(file_info)
      connection.execute(
        files_sql_statement,
        file_info.relative_path,
        file_info.mime_type,
        file_info.mime_subtype,
        file_info.bytesize,
        file_info.last_modified_at.to_s,
        file_info.digest,
        Time.now.utc.to_s
      )
    end

    def insert_content(file_info)
      connection.execute(
        contents_sql_statement,
        file_info.digest,
        file_info.contents,
        Time.now.utc.to_s
      )
    end

    def ensure_dir_exists(path)
      dir = File.dirname(path)

      FileUtils.mkdir_p(dir)
    end

    def files_sql_statement
      'INSERT OR IGNORE INTO files VALUES (?, ?, ?, ?, ?, ?, ?)'
    end

    def contents_sql_statement
      'INSERT OR IGNORE INTO contents VALUES (?, ?, ?)'
    end

    def load_schema
      load_files_schema
      load_contents_schema
    end

    def load_files_schema
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

    def load_contents_schema
      connection.execute <<-SQL
        CREATE TABLE IF NOT EXISTS contents (
          digest varchar NOT NULL,
          data blob,
          created_at datetime NOT NULL
        );
      SQL

      connection.execute <<-SQL
        CREATE UNIQUE INDEX IF NOT EXISTS idx_contents_digest ON contents (digest);
      SQL
    end
  end
end
