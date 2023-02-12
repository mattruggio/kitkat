# frozen_string_literal: true

require 'spec_helper'

describe Kitkat do
  let(:db)         { File.join('tmp', "#{SecureRandom.uuid}.db") }
  let(:path)       { fixture('example_dir') }
  let(:io)         { StringIO.new }
  let(:connection) { SQLite3::Database.new(db) }

  describe '#crawl' do
    before do
      described_class.crawl(db:, path:, io:)
    end

    after do
      FileUtils.rm_f(db)
    end

    # A superficial count test.
    it 'inserted a file record for each file and folder found in path' do
      connection.execute('SELECT COUNT(*) FROM files') do |row|
        expect(row.first).to eq(4)
      end
    end

    it 'writes each relative_path found in path to io' do
      relative_paths = [
        "hello_world\n",
        "hello_world/hello_world.txt\n",
        "hello_world.txt\n",
        "hello_world2.txt\n"
      ]

      relative_paths.each do |relative_path|
        expect(io.string).to include(relative_path)
      end
    end
  end
end
