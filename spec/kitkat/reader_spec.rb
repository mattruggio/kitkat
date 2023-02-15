# frozen_string_literal: true

require 'spec_helper'

describe Kitkat::Reader do
  subject(:reader) { described_class.new(path) }

  let(:path) { fixture('example_dir') }

  let(:relative_paths) do
    %w[
      hello_world
      hello_world/earth.jpg
      hello_world/hello_world.txt
      hello_world.txt
      hello_world2.txt
      jupiter.jpg
    ]
  end

  describe '#each' do
    it 'recursively lists all files' do
      actual_relative_paths = reader.map(&:relative_path)

      expect(actual_relative_paths).to match_array(relative_paths)
    end
  end
end
