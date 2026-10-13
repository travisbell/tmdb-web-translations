# frozen_string_literal: true

RSpec.describe "pluralization for ro-RO" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "ro-RO", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "ro-RO")
    expect(plural_keys).to eq([:one, :few, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:few)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:few)
    expect(rule.call(19)).to eq(:few)
    expect(rule.call(20)).to eq(:other)
    expect(rule.call(21)).to eq(:other)
    expect(rule.call(100)).to eq(:other)
    expect(rule.call(101)).to eq(:few)
    expect(rule.call(120)).to eq(:other)
  end
end
