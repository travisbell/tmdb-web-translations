# frozen_string_literal: true

RSpec.describe "pluralization for lt-LT" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "lt-LT", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "lt-LT")
    expect(plural_keys).to eq([:one, :few, :many])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:many)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:few)
    expect(rule.call(3)).to eq(:few)
    expect(rule.call(9)).to eq(:few)
    expect(rule.call(10)).to eq(:many)
    expect(rule.call(11)).to eq(:many)
    expect(rule.call(19)).to eq(:many)
    expect(rule.call(21)).to eq(:one)
    expect(rule.call(100)).to eq(:many)
    expect(rule.call(101)).to eq(:one)
    expect(rule.call(111)).to eq(:many)
  end
end
