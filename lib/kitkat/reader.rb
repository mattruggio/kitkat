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

    def each(&block)
      return enum_for(:each) unless block_given?

      traverse(root, &block)

      self
    end

    private

    def traverse(dir, &block)
      Dir[File.join(dir, '*')].each do |path|
        yield FileInfo.new(path, root: root)

        traverse(path, &block) if File.directory?(path)
      end
    end
  end
end
