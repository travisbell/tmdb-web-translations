# frozen_string_literal: true

require "tmpdir"
require "open3"
require "rbconfig"
require "yaml"

RSpec.describe "translation scripts" do
  let(:repository) { File.expand_path("..", __dir__) }

  around do |example|
    Dir.mktmpdir("tmdb-script-spec") do |directory|
      @directory = directory
      example.run
    end
  end

  def fixture(name, text)
    path = File.join(@directory, name)
    File.write(path, text)
    path
  end

  def run_script(name, *args, env: {})
    Open3.capture3(env, RbConfig.ruby, File.join(repository, "script", name), *args, chdir: @directory)
  end

  def expect_untouched(path)
    text = File.read(path)
    File.utime(Time.at(123456789), Time.at(123456789), path)
    before = File.stat(path)
    yield
    expect(File.read(path)).to eq(text)
    expect(File.stat(path).ino).to eq(before.ino)
    expect(File.stat(path).mtime).to eq(before.mtime)
  end

  example "leaves an already sorted file and its metadata untouched" do
    path = fixture("en-US.yml", "# Keep this comment\nen-US:\n  a: 'Film'\n  z: \"TV series\"\n")
    expect_untouched(path) do
      _, error, status = run_script("sort.rb", path)
      expect(status.success?).to be(true), error
    end
  end

  example "leaves an already patched file and its metadata untouched" do
    reference = fixture("reference.yml", "en-US:\n  a: Film\n  z: TV series\n")
    target = fixture("en-US.yml", "# Keep this comment\nen-US:\n  a: 'Film'\n  z: \"TV series\"\n")
    expect_untouched(target) do
      _, error, status = run_script("patch.rb", reference, target)
      expect(status.success?).to be(true), error
    end
  end

  example "leaves an unchanged split destination and its metadata untouched" do
    Dir.mkdir(File.join(@directory, "locales"))
    reference = fixture("source.yml", "pt-PT:\n  a: Filme\n  z: Série\n")
    target = fixture("locales/pt-PT.yml", "# Keep this comment\npt-PT:\n  a: 'Filme'\n  z: \"Série\"\n")
    expect_untouched(target) do
      _, error, status = run_script("split.rb", reference)
      expect(status.success?).to be(true), error
    end
  end

  example "sorts successfully when TMPDIR is on a different filesystem" do
    skip "requires a separate tmpfs" unless File.directory?("/dev/shm") && File.stat("/dev/shm").dev != File.stat(@directory).dev
    path = fixture("en-US.yml", "en-US:\n  z: last\n  a: first\n")
    _, error, status = run_script("sort.rb", path, env: { "TMPDIR" => "/dev/shm" })
    expect(status.success?).to be(true), error
    expect(YAML.safe_load_file(path)).to eq("en-US" => { "a" => "first", "z" => "last" })
  end

  example "does not rewrite a file containing duplicate keys" do
    text = "en-US:\n  key: first\n  key: second\n"
    path = fixture("en-US.yml", text)
    _, error, status = run_script("sort.rb", path)
    expect(status.success?).to be(false)
    expect(error).to include("duplicate")
    expect(File.read(path)).to eq(text)
  end

  example "does not delete the source on a rename collision" do
    text = "en-US:\n  old: source\n  new: existing\n"
    path = fixture("en-US.yml", text)
    _, error, status = run_script("rename-key.rb", "--old-key", "old", "--new-key", "new", path)
    expect(status.success?).to be(false)
    expect(error).to include("already exists")
    expect(File.read(path)).to eq(text)
  end

  example "copies plural translations without creating blank slots" do
    path = fixture("en-US.yml", "en-US:\n  old:\n    one: 1 film\n    other: '%{count} films'\n")
    _, error, status = run_script("copy-key.rb", "--old-key", "old", "--new-key", "new", path)
    expect(status.success?).to be(true), error
    data = YAML.safe_load_file(path)["en-US"]
    expect(data["new"]).to eq("one" => "1 film", "other" => "%{count} films")
    expect(data["old"]).to eq(data["new"])
  end

  example "honours --no-sort-keys when patching" do
    reference = fixture("reference.yml", "en-US:\n  z: last\n  a: first\n")
    target = fixture("en-US.yml", "en-US:\n  z: last\n  a: first\n")
    _, error, status = run_script("patch.rb", "--no-sort-keys", reference, target)
    expect(status.success?).to be(true), error
    expect(YAML.safe_load_file(target)["en-US"].keys).to eq(["z", "a"])
  end

  example "creates split files that do not exist yet" do
    Dir.mkdir(File.join(@directory, "locales"))
    reference = fixture("source.yml", "en-US:\n  title: Film\npt-PT:\n  title: Filme\n")
    _, error, status = run_script("split.rb", reference)
    expect(status.success?).to be(true), error
    expect(YAML.safe_load_file(File.join(@directory, "locales", "pt-PT.yml"))).to eq("pt-PT" => { "title" => "Filme" })
  end

  example "refuses global rename collisions before rewriting the file" do
    text = "en-US:\n  old: source\n  global:\n    new: existing\n"
    path = fixture("en-US.yml", text)
    mapping = fixture("mapping.yml", "old: global.new\n")
    _, error, status = run_script("rename_global.rb", "--mapping", mapping, path)
    expect(status.success?).to be(false)
    expect(error).to include("already exists")
    expect(File.read(path)).to eq(text)
  end

  example "returns a failure status for an incorrect locale root" do
    path = fixture("pt-PT.yml", "en-US:\n  title: Film\n")
    _, error, status = run_script("locale_check.rb", path)
    expect(status.success?).to be(false)
    expect(error).to include("pt-PT")
  end

  example "finds absent keys, whitespace and array blanks from the English source" do
    Dir.mkdir(File.join(@directory, "locales"))
    fixture("locales/en-US.yml", "en-US:\n  absent: Film\n  blank: Series\n  list:\n    - Episode\n  number:\n    format:\n      delimiter: ','\n")
    fixture("locales/pt-PT.yml", "pt-PT:\n  blank: '  '\n  list:\n    - ''\n")
    output, error, status = run_script("find_blanks.rb", "--directory", @directory, "pt-PT")
    expect(status.success?).to be(true), error
    expect(output.lines.grep(/^BLANK:/).size).to eq(3)
    expect(output).to include("BLANK: absent", "BLANK: blank", "BLANK: list.0")
    expect(output).not_to include("number.format")
  end
end
