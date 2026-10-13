# frozen_string_literal: true

RSpec.describe "pluralization for fr-CA" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "fr-CA", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "fr-CA")
    expect(plural_keys).to eq([:one, :many, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:one)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:other)
    expect(rule.call(3)).to eq(:other)
    expect(rule.call(1000000)).to eq(:many)
    expect(rule.call(2000000)).to eq(:many)
  end
end
