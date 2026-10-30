# frozen_string_literal: true

require "tmpdir"
require "tmdb/pluralization_files"

RSpec.describe TMDb::PluralizationFiles do
  around do |example|
    Dir.mktmpdir("tmdb-plurals-") do |directory|
      @directory = directory
      example.run
    end
  end

  it "preserves pt-PT's Weblate rule, including many, when replacing a Rails wrapper" do
    path = File.join(@directory, "pt-PT.rb")
    File.write(path, "require 'rails_i18n/common_pluralizations/one_other'\n\n::RailsI18n::Pluralization::OneOther.with_locale(:'pt-PT')\n")
    generator = described_class.new("pt-PT" => "one_many_other")
    expect(generator.write(@directory)).to eq(["pt-PT"])
    expect(File.read(path)).to include("weblate/pluralization/one_many_other", "::Weblate::Pluralization::OneManyOther")
    expect(generator.write(@directory)).to eq([])
  end

  it "keeps equivalent quoting and whitespace without rewriting the wrapper" do
    path = File.join(@directory, "pt-PT.rb")
    original = "require \"weblate/pluralization/one_many_other\"\n\n::Weblate::Pluralization::OneManyOther.with_locale(:\"pt-PT\")\n"
    File.write(path, original)
    generator = described_class.new("pt-PT" => "one_many_other")
    expect(generator.write(@directory)).to eq([])
    expect(File.read(path)).to eq(original)
  end

  it "refuses unconfigured wrappers without overwriting configured files" do
    File.write(File.join(@directory, "xx-XX.rb"), "custom")
    generator = described_class.new("pt-PT" => "one_many_other")
    expect { generator.write(@directory) }.to raise_error(ArgumentError, /unmapped/)
    expect(Dir.children(@directory)).to eq(["xx-XX.rb"])
  end

  it "does not accept extra executable statements as equivalent wrappers" do
    generator = described_class.new("pt-PT" => "one_many_other")
    File.write(File.join(@directory, "pt-PT.rb"), generator.render("pt-PT") + "puts 'extra'\n")
    expect(generator.differences(@directory).first).to eq(["pt-PT"])
  end
end
