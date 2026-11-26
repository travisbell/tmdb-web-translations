# frozen_string_literal: true

require "tmpdir"
require "open3"
require "rbconfig"
require "yaml"
require "tmdb/yaml_file"
require "tmdb/i18n_missing_translations"

RSpec.describe "review improvements" do
  let(:repository) { File.expand_path("..", __dir__) }

  around do |example|
    Dir.mktmpdir("tmdb-review-spec") do |directory|
      @directory = directory
      example.run
    end
  end

  def fixture(name, text)
    path = File.join(@directory, name)
    File.write(path, text)
    path
  end

  def run_script(name, *args)
    Open3.capture3(RbConfig.ruby, File.join(repository, "script", name), *args, chdir: @directory)
  end

  example "does not report source plural categories the target locale never selects" do
    source = { "items" => { "one" => "%{count} item", "other" => "%{count} items", "two" => "items" }, "wins" => { "zero" => "No wins", "other" => "%{count} wins" } }
    target = { "items" => { "other" => "%{count} 件" }, "wins" => { "other" => "%{count} 勝" } }
    expect(I18nMissingTranslations.find(source, target, plural_keys: ["other"])).to eq([[["wins", "zero"], "No wins"]])
    expect(I18nMissingTranslations.find(source, target).map(&:first)).to include(["items", "one"], ["items", "two"])
  end

  example "find_blanks uses the target locale's plural categories" do
    Dir.mkdir(File.join(@directory, "locales"))
    fixture("locales/en-US.yml", "en-US:\n  items:\n    one: '%{count} item'\n    other: '%{count} items'\n")
    fixture("locales/ja-JP.yml", "ja-JP:\n  items:\n    other: '%{count} 件'\n")
    fixture("locales/de-DE.yml", "de-DE:\n  items:\n    other: '%{count} Elemente'\n")
    output, error, status = run_script("find_blanks.rb", "--directory", @directory, "ja-JP", "de-DE")
    expect(status.success?).to be(true), error
    expect(output.lines.grep(/^BLANK:/)).to eq(["BLANK: items.one => \"%{count} item\"\n"])
    expect(output.index("# de-DE")).to be < output.index("BLANK:")
  end

  example "validates every file before rewriting any of them" do
    first = fixture("aa-AA.yml", "aa-AA:\n  old: a\n")
    second_text = "bb-BB:\n  old: b\n  new: existing\n"
    second = fixture("bb-BB.yml", second_text)
    _, error, status = run_script("rename-key.rb", "--old-key", "old", "--new-key", "new", first, second)
    expect(status.success?).to be(false)
    expect(error).to include("already exists")
    expect(File.read(first)).to eq("aa-AA:\n  old: a\n")
    expect(File.read(second)).to eq(second_text)
  end

  example "leaves a file byte-identical when the command changes no data" do
    text = "en-US:\n  quoted: \"kept as written\"\n  wrapped: first\n    second\n"
    path = fixture("en-US.yml", text)
    _, error, status = run_script("delete-key.rb", "--key", "absent.key", path)
    expect(status.success?).to be(true), error
    expect(File.read(path)).to eq(text)
  end

  example "still rewrites when only the key order changes" do
    path = fixture("en-US.yml", "en-US:\n  z:\n    b: 2\n    a: 1\n")
    _, error, status = run_script("sort.rb", path)
    expect(status.success?).to be(true), error
    expect(YAML.safe_load_file(path)["en-US"]["z"].keys).to eq(["a", "b"])
  end

  example "replaces the target of a symlink instead of the symlink" do
    real = fixture("real.yml", "en-US:\n  old: value\n")
    link = File.join(@directory, "en-US.yml")
    File.symlink(real, link)
    _, error, status = run_script("rename-key.rb", "--old-key", "old", "--new-key", "new", link)
    expect(status.success?).to be(true), error
    expect(File.symlink?(link)).to be(true)
    expect(YAML.safe_load_file(real)).to eq("en-US" => { "new" => "value" })
  end

  example "refuses to generate a global mapping with colliding destinations" do
    path = fixture("en-US.yml", "en-US:\n  Remove: A\n  Remove?: B\n")
    output_path = File.join(@directory, "mapping.yml")
    _, error, status = run_script("rename_global.rb", "--output", output_path, path)
    expect(status.success?).to be(false)
    expect(error).to include("global.remove", "Remove?")
    expect(File.exist?(output_path)).to be(false)
  end
end
