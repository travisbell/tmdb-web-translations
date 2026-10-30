# frozen_string_literal: true

require "tmdb/i18n_rename"
require "tmdb/i18n_delete"

RSpec.describe "translation mutation regressions" do
  [nil, false, 42, ["a", "b"], { "one" => "1 film", "other" => "%{count} films" }].each do |value|
    example "renames and copies #{value.inspect} without blanking it" do
      target = { "en-US" => { "old" => value } }
      original = Marshal.load(Marshal.dump(target))
      moved = I18nRename.new(old_key: ["old"], new_key: ["new"]).apply(target)
      copied = I18nRename.new(old_key: ["old"], new_key: ["new"]).apply(target, delete_old_key: false)
      expect(moved).to eq("en-US" => { "new" => value })
      expect(copied).to eq("en-US" => { "old" => value, "new" => value })
      expect(target).to eq(original)
    end

    example "deletes a key whose value is #{value.inspect}" do
      target = { "en-US" => { "parent" => { "remove" => value }, "keep" => "yes" } }
      expect(I18nDelete.new(delete_key: ["parent", "remove"]).apply(target)).to eq("en-US" => { "keep" => "yes" })
    end
  end

  [nil, false, "existing", {}].each do |value|
    example "refuses a collision with #{value.inspect} and leaves both values intact" do
      target = { "en-US" => { "old" => "source", "new" => value } }
      original = Marshal.load(Marshal.dump(target))
      expect { I18nRename.new(old_key: ["old"], new_key: ["new"]).apply(target) }.to raise_error(ArgumentError, /already exists/)
      expect(target).to eq(original)
    end
  end

  example "does nothing when the source and destination are identical" do
    target = { "en-US" => { "old" => { "other" => "%{count} films" } } }
    expect(I18nRename.new(old_key: ["old"], new_key: ["old"]).apply(target)).to eq(target)
  end

  example "keeps copied arrays and plural maps independent of the source" do
    target = { "en-US" => { "old" => { "other" => ["a"] } } }
    result = I18nRename.new(old_key: ["old"], new_key: ["new"]).apply(target, delete_old_key: false)
    result["en-US"]["new"]["other"] << "b"
    expect(result["en-US"]["old"]["other"]).to eq(["a"])
    expect(target["en-US"]["old"]["other"]).to eq(["a"])
  end

  example "refuses scalar destination parents without modifying the input" do
    target = { "en-US" => { "old" => "source", "parent" => false } }
    expect { I18nRename.new(old_key: ["old"], new_key: ["parent", "new"]).apply(target) }.to raise_error(ArgumentError, /not a mapping/)
    expect(target).to eq("en-US" => { "old" => "source", "parent" => false })
  end

  example "refuses ancestor and descendant destinations" do
    [[%w[parent child], ["parent"]], [["parent"], %w[parent child]]].each do |old_key, new_key|
      expect { I18nRename.new(old_key:, new_key:).apply({ "en-US" => { "parent" => { "child" => "value" } } }) }.to raise_error(ArgumentError, /overlap/)
    end
  end

  example "preserves unrelated data when paths are missing" do
    target = { "en-US" => { "parent" => false, "keep" => "yes" } }
    expect(I18nRename.new(old_key: %w[parent absent], new_key: ["new"]).apply(target)).to eq(target)
    expect(I18nDelete.new(delete_key: %w[parent absent]).apply(target)).to eq(target)
  end
end
