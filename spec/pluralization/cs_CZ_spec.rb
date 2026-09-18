# frozen_string_literal: true

RSpec.describe "pluralization for cs-CZ" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "cs-CZ", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "cs-CZ")
    expect(plural_keys).to eq([:one, :few, :many])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:many)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:few)
    expect(rule.call(3)).to eq(:few)
    expect(rule.call(4)).to eq(:few)
    expect(rule.call(5)).to eq(:many)
  end
end
