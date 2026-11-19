# frozen_string_literal: true

require "tmpdir"
require "tmdb/yaml_file"

RSpec.describe TMDb::YamlFile do
  around do |example|
    Dir.mktmpdir("tmdb-yaml-") do |directory|
      @path = File.join(directory, "pt-PT.yml")
      example.run
    end
  end

  it "rejects nested duplicate keys before a rewrite can discard their values" do
    File.write(@path, "pt-PT:\n  nested:\n    name: first\n    'name': second\n")
    expect { described_class.load(@path) }.to raise_error(described_class::InvalidYaml, /duplicate key.*name/)
    expect(File.read(@path)).to include("first", "second")
  end

  it "rejects duplicate keys inside array elements" do
    File.write(@path, "pt-PT:\n  items:\n    - name: first\n      name: second\n")
    expect { described_class.load(@path) }.to raise_error(described_class::InvalidYaml, /duplicate key/)
  end

  it "rejects implicitly typed ISO codes but accepts quoted codes" do
    File.write(@path, "pt-PT:\n  countries:\n    NO: Noruega\n")
    expect { described_class.load(@path) }.to raise_error(described_class::InvalidYaml, /non-string key/)
    File.write(@path, "pt-PT:\n  countries:\n    'NO': Noruega\n")
    expect(described_class.load(@path)["pt-PT"]["countries"]["NO"]).to eq("Noruega")
  end

  it "requires exactly the requested locale root" do
    File.write(@path, "pt-PT: {}\nen-US: {}\n")
    expect { described_class.load(@path, locale: "pt-PT") }.to raise_error(described_class::InvalidYaml, /expected only root/)
  end

  it "rejects invalid UTF-8" do
    File.binwrite(@path, "pt-PT:\n  name: \xff\n")
    expect { described_class.load(@path) }.to raise_error(described_class::InvalidYaml, /invalid UTF-8/)
  end

  example "rejects extra YAML documents instead of silently discarding them" do
    File.write(@path, "en-US:\n  first: keep\n---\npt-PT:\n  second: keep\n")
    expect { described_class.load(@path) }.to raise_error(described_class::InvalidYaml, /exactly one YAML document/)
  end

  it "preserves bytes and file metadata when original is omitted" do
    text = "# Keep this comment\npt-PT:\n  name: 'Filme'\n  wrapped: first\n    second\n"
    File.write(@path, text)
    File.utime(Time.at(123456789), Time.at(123456789), @path)
    before = File.stat(@path)

    expect(described_class.write(@path, described_class.load(@path))).to be(false)
    expect(File.read(@path)).to eq(text)
    expect(File.stat(@path).ino).to eq(before.ino)
    expect(File.stat(@path).mtime).to eq(before.mtime)
  end

  it "still writes changed values when original is omitted" do
    File.write(@path, "pt-PT:\n  name: Filme\n")

    expect(described_class.write(@path, { "pt-PT" => { "name" => "Série" } })).to be(true)
    expect(described_class.load(@path)).to eq("pt-PT" => { "name" => "Série" })
  end

  it "refuses to replace an invalid existing destination" do
    text = "pt-PT:\n  name: first\n  name: second\n"
    File.write(@path, text)

    expect do
      described_class.write(@path, { "pt-PT" => { "name" => "Filme" } })
    end.to raise_error(described_class::InvalidYaml, /duplicate key/)
    expect(File.read(@path)).to eq(text)
  end

  it "preserves a symlink and its target when no data changes" do
    text = "pt-PT:\n  name: 'Filme'\n"
    File.write(@path, text)
    link = File.join(File.dirname(@path), "link.yml")
    File.symlink(@path, link)
    before = File.stat(@path)

    expect(described_class.write(link, described_class.load(link))).to be(false)
    expect(File.symlink?(link)).to be(true)
    expect(File.read(@path)).to eq(text)
    expect(File.stat(@path).ino).to eq(before.ino)
    expect(File.stat(@path).mtime).to eq(before.mtime)
  end
end
