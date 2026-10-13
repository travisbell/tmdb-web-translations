# frozen_string_literal: true

RSpec.describe "pluralization for sl-SI" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "sl-SI", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "sl-SI")
    expect(plural_keys).to eq([:one, :two, :few, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:other)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:two)
    expect(rule.call(3)).to eq(:few)
    expect(rule.call(4)).to eq(:few)
    expect(rule.call(5)).to eq(:other)
    expect(rule.call(100)).to eq(:other)
    expect(rule.call(101)).to eq(:one)
    expect(rule.call(102)).to eq(:two)
    expect(rule.call(103)).to eq(:few)
    expect(rule.call(104)).to eq(:few)
    expect(rule.call(105)).to eq(:other)
  end
end
