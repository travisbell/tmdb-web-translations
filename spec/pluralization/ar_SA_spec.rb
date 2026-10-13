# frozen_string_literal: true

RSpec.describe "pluralization for ar-SA" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "ar-SA", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "ar-SA")
    expect(plural_keys).to eq([:zero, :one, :two, :few, :many, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:zero)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:two)
    expect(rule.call(3)).to eq(:few)
    expect(rule.call(10)).to eq(:few)
    expect(rule.call(11)).to eq(:many)
    expect(rule.call(99)).to eq(:many)
    expect(rule.call(100)).to eq(:other)
    expect(rule.call(102)).to eq(:other)
    expect(rule.call(111)).to eq(:many)
  end
end
