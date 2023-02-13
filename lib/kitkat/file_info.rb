# frozen_string_literal: true
# typed: strict

module Kitkat
  # File-level operations.
  class FileInfo
    extend T::Sig

    BLANK               = T.let('', String)
    MIME_TYPE_SEPARATOR = T.let('/', String)

    sig { returns(String) }
    attr_reader :full_mime_type, :path, :root

    sig { params(path: String, root: String).void }
    def initialize(path, root: BLANK)
      @path           = path
      @root           = root
      @full_mime_type = T.let(read_full_mime_type, String)
    end

    sig { returns(String) }
    def relative_path
      path.delete_prefix(root).delete_prefix(File::SEPARATOR)
    end

    sig { returns(String) }
    def mime_type
      full_mime_type.split(MIME_TYPE_SEPARATOR).first.to_s
    end

    sig { returns(String) }
    def mime_subtype
      full_mime_type.split(MIME_TYPE_SEPARATOR).last.to_s
    end

    # Important note: Calling this on a directory will result in a blank string.
    sig { returns(String) }
    def digest
      File.directory?(path) ? BLANK : Digest::SHA256.file(path).hexdigest
    end

    sig { returns(Time) }
    def last_modified_at
      File.mtime(path).utc
    end

    sig { returns(Integer) }
    def bytesize
      File.size(path)
    end

    private

    sig { returns(String) }
    def read_full_mime_type
      IO.popen(
        ['file', '--brief', '--mime-type', path],
        in: :close, err: :close
      ) { |io| io.read.chomp }.to_s
    end
  end
end
