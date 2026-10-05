# frozen_string_literal: true

require "tmpdir"
require "tmdb/atomic_file"

RSpec.describe TMDb::AtomicFile do
  around do |example|
    Dir.mktmpdir("tmdb-atomic-") do |directory|
      @directory = directory
      @path = File.join(directory, "pt-PT.yml")
      example.run
    end
  end

  it "creates a new file and cleans up the temporary file" do
    described_class.write(@path, "pt-PT:\n  name: Séries\n")
    expect(File.read(@path)).to include("Séries")
    expect(Dir.children(@directory)).to eq(["pt-PT.yml"])
  end

  it "preserves the old file and cleans up if the final rename fails" do
    File.write(@path, "original")
    allow(File).to receive(:rename).and_raise(Errno::EACCES)
    expect { described_class.write(@path, "replacement") }.to raise_error(Errno::EACCES)
    expect(File.read(@path)).to eq("original")
    expect(Dir.children(@directory)).to eq(["pt-PT.yml"])
  end

  it "writes beside the destination, closes before rename and preserves permissions" do
    File.write(@path, "original")
    File.chmod(0o640, @path)
    allow(File).to receive(:rename).and_wrap_original do |rename, source, destination|
      expect(File.dirname(source)).to eq(File.dirname(destination))
      expect(File.read(source)).to eq("complete replacement")
      expect(File.stat(source).mode & 0o777).to eq(0o640)
      rename.call(source, destination)
    end
    described_class.write(@path, "complete replacement")
    expect(File.read(@path)).to eq("complete replacement")
    expect(File.stat(@path).mode & 0o777).to eq(0o640)
  end
end
