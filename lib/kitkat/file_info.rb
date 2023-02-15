# frozen_string_literal: true

module Kitkat
  # File-level operations.
  class FileInfo
    BLANK               = ''
    MIME_TYPE_SEPARATOR = '/'
    STORABLE_MIME_TYPES = %w[image text].to_set.freeze

    attr_reader :path, :root

    def initialize(path, root: BLANK)
      @path = path
      @root = root
    end

    def relative_path
      path.delete_prefix(root).delete_prefix(File::SEPARATOR)
    end

    def full_mime_type
      @full_mime_type ||= IO.popen(
        ['file', '--brief', '--mime-type', path],
        in: :close, err: :close
      ) { |io| io.read.chomp }.to_s
    end

    def mime_type
      full_mime_type.split(MIME_TYPE_SEPARATOR).first
    end

    def mime_subtype
      full_mime_type.split(MIME_TYPE_SEPARATOR).last
    end

    # Important note: Calling this on a directory will result in a blank string.
    def digest
      @digest ||= read_digest
    end

    def last_modified_at
      File.mtime(path).utc
    end

    def bytesize
      @bytesize ||= File.size(path)
    end

    def contents
      @contents ||= read_contents
    end

    def storable?
      STORABLE_MIME_TYPES.include?(mime_type)
    end

    private

    def read_digest
      File.directory?(path) ? BLANK : Digest::SHA256.file(path).hexdigest
    end

    def read_contents
      IO.binread(path) if storable?
    end
  end
end
