# frozen_string_literal: true

require "tmdb/i18n_missing_translations"

RSpec.describe I18nMissingTranslations do
  it "finds absent branches, nil, empty and whitespace-only text" do
    source = { "nil" => "Nil", "empty" => "Empty", "space" => "Space", "missing" => { "leaf" => "Missing" }, "done" => "Done" }
    target = { "nil" => nil, "empty" => "", "space" => " \n\t", "done" => "Feito" }
    expect(described_class.find(source, target)).to eq([
      [["nil"], "Nil"], [["empty"], "Empty"], [["space"], "Space"], [["missing", "leaf"], "Missing"]
    ])
  end

  it "traverses array elements and nested mappings with explicit indices" do
    source = { "names" => [nil, "First", { "label" => "Second" }, "Third"] }
    target = { "names" => [nil, "Primeiro", { "label" => "" }] }
    expect(described_class.find(source, target)).to eq([
      [["names", 2, "label"], "Second"], [["names", 3], "Third"]
    ])
  end

  it "does not turn nulls, blank sources, numeric settings or number formats into translation tasks" do
    source = { "null" => nil, "empty" => "", "space" => " ", "precision" => 2, "enabled" => true, "number" => { "format" => { "delimiter" => "," }, "unit" => "Million" } }
    expect(described_class.find(source, {})).to eq([])
  end

  it "does not flag legitimate identical translations or target-only plural categories" do
    source = { "name" => "Digital", "items" => { "one" => "Item", "other" => "Items" } }
    target = { "name" => "Digital", "items" => { "one" => "Item", "other" => "Itens", "many" => "" } }
    expect(described_class.find(source, target)).to eq([])
  end
  example "recognizes Unicode whitespace without treating it as translated text" do
    source = { "missing" => "Film", "empty_source" => "\u3000\u00a0" }
    target = { "missing" => "\u3000\u00a0", "empty_source" => nil }
    expect(described_class.find(source, target)).to eq([[["missing"], "Film"]])
  end
end
