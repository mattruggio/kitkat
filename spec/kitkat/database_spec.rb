# frozen_string_literal: true

require 'spec_helper'

describe Kitkat::Database do
  subject(:db) { described_class.new(path) }

  let(:path)       { File.join('tmp', "#{SecureRandom.uuid}.db") }
  let(:connection) { SQLite3::Database.new(path) }

  let(:file_info) do
    Kitkat::FileInfo.new(fixture('example_dir', 'hello_world.txt'))
  end

  describe '#insert' do
    before do
      db.insert(file_info)
    end

    after do
      FileUtils.rm_f(path)
    end

    # A superficial count test.
    it 'inserts a record into the files table' do
      connection.execute('SELECT COUNT(*) FROM files') do |row|
        expect(row.first).to eq(1)
      end
    end
  end
end
