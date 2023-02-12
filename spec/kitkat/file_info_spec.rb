# frozen_string_literal: true

require 'spec_helper'

describe Kitkat::FileInfo do
  subject(:file_info) { described_class.new(path, root:) }

  context 'when path is for a simple text file' do
    let(:root)     { fixture('example_dir') }
    let(:filename) { 'hello_world.txt' }
    let(:path)     { File.join(root, filename) }

    describe '#initialize' do
      it 'sets path' do
        expect(file_info.path).to eq(path)
      end

      it 'sets root' do
        expect(file_info.root).to eq(root)
      end
    end

    specify '#relative_path returns path without root' do
      expect(file_info.relative_path).to eq(filename)
    end

    specify '#mime_type returns text' do
      expect(file_info.mime_type).to eq('text')
    end

    specify '#mime_subtype returns plain' do
      expect(file_info.mime_subtype).to eq('plain')
    end

    specify '#digest returns SHA256 of file contents' do
      sha256_hash = 'c98c24b677eff44860afea6f493bbaec5bb1c4cbb209c6fc2bbb47f66ff2ad31'

      expect(file_info.digest).to eq(sha256_hash)
    end

    specify '#bytesize returns the size of the file' do
      expect(file_info.bytesize).to eq(14)
    end

    # This one is a bit harder to make deterministic since the file system can produce different
    # results.  I suppose we could mock File in order to ensure our FileInfo class is as
    # deterministic as possible (this might be the best option for expanding the test suite here.)
    specify '#last_modified_at returns the last date the file was modified' do
      expect(file_info.last_modified_at).to eq(File.mtime(file_info.path))
    end
  end
end
