# frozen_string_literal: true

RSpec.describe "pluralization for es-ES" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "es-ES", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "es-ES")
    expect(plural_keys).to eq([:one, :many, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:other)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:other)
    expect(rule.call(3)).to eq(:other)
    expect(rule.call(1000000)).to eq(:many)
    expect(rule.call(1500000)).to eq(:other)
    expect(rule.call(2000000)).to eq(:many)
  end
end
