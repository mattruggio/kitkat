# frozen_string_literal: true

require_relative 'file_info'

module Kitkat
  # Directory operations.
  class Reader
    include Enumerable

    attr_reader :root

    def initialize(root)
      @root = File.expand_path(root)

      freeze
    end

    def each(&)
      return enum_for(:each) unless block_given?

      traverse(root, &)

      self
    end

    private

    def traverse(dir, &)
      Dir[File.join(dir, '*')].each do |path|
        yield FileInfo.new(path, root:)

        traverse(path, &) if File.directory?(path)
      end
    end
  end
end
