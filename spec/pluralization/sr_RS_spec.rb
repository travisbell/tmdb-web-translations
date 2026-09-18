# frozen_string_literal: true

RSpec.describe "pluralization for sr-RS" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "sr-RS", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "sr-RS")
    expect(plural_keys).to eq([:one, :few, :many])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:many)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:few)
    expect(rule.call(4)).to eq(:few)
    expect(rule.call(5)).to eq(:many)
    expect(rule.call(11)).to eq(:many)
    expect(rule.call(12)).to eq(:many)
    expect(rule.call(14)).to eq(:many)
    expect(rule.call(21)).to eq(:one)
    expect(rule.call(22)).to eq(:few)
    expect(rule.call(25)).to eq(:many)
    expect(rule.call(100)).to eq(:many)
    expect(rule.call(101)).to eq(:one)
    expect(rule.call(112)).to eq(:many)
  end
end
