# frozen_string_literal: true

require "tmpdir"
require "tmdb/yaml_file"
require "tmdb/i18n_missing_translations"

RSpec.describe "independent review follow-up" do
  example "reports a missing target-only plural category with English other context" do
    source = { "items" => { "one" => "One item", "other" => "%{count} items" } }
    target = { "items" => { "one" => "Um item", "other" => "%{count} itens" } }
    expect(I18nMissingTranslations.find(source, target, plural_keys: %w[one many other])).to eq([[["items", "many"], "%{count} items"]])
  end

  example "reports all required Arabic categories without requesting English-only categories" do
    source = { "items" => { "one" => "One item", "other" => "%{count} items", "many" => "Unused English category" } }
    target = { "items" => { "one" => "واحد", "other" => "%{count}" } }
    paths = I18nMissingTranslations.find(source, target, plural_keys: %w[zero one two few many other]).map(&:first)
    expect(paths).to match_array([%w[items zero], %w[items two], %w[items few], %w[items many]])
  end

  example "includes displayed units while excluding numeric format templates and invisible unit suffixes" do
    source = { "number" => { "format" => { "delimiter" => "," }, "human" => { "format" => { "format" => "%n %u" }, "decimal_units" => { "units" => { "million" => "Million" } }, "short_decimal_units" => { "units" => { "unit" => "\u00ad" } } } } }
    expect(I18nMissingTranslations.find(source, {})).to eq([[%w[number human decimal_units units million], "Million"]])
  end

  example "accepts Rails symbol values but still rejects symbol keys" do
    Dir.mktmpdir do |directory|
      path = File.join(directory, "pt-PT.yml")
      File.write(path, "pt-PT:\n  date:\n    order:\n      - :day\n      - :month\n      - :year\n")
      expect(TMDb::YamlFile.load(path)["pt-PT"]["date"]["order"]).to eq([:day, :month, :year])
      File.write(path, "pt-PT:\n  :symbol_key: value\n")
      expect { TMDb::YamlFile.load(path) }.to raise_error(TMDb::YamlFile::InvalidYaml, /non-string key/)
    end
  end

  example "preserves a dangling symlink instead of replacing it with a regular file" do
    Dir.mktmpdir do |directory|
      target = File.join(directory, "missing.yml")
      link = File.join(directory, "link.yml")
      File.symlink(target, link)
      expect { TMDb::AtomicFile.write(link, "replacement") }.to raise_error(Errno::ENOENT)
      expect(File.symlink?(link)).to be(true)
      expect(File.exist?(target)).to be(false)
    end
  end

  example "keeps all earlier files unchanged when a later YAML is invalid" do
    Dir.mktmpdir do |directory|
      first = File.join(directory, "first.yml")
      second = File.join(directory, "second.yml")
      text = "en-US:\n  old: preserve\n"
      File.write(first, text)
      File.write(second, "en-US:\n  key: first\n  key: second\n")
      expect do
        TMDb::YamlFile.update_all([first, second]) do |_path, data|
          data["en-US"]["old"] = "changed"
          data
        end
      end.to raise_error(TMDb::YamlFile::InvalidYaml)
      expect(File.read(first)).to eq(text)
    end
  end
end
