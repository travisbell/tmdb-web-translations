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
end
