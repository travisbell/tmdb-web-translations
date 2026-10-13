# frozen_string_literal: true

RSpec.describe "pluralization for lv-LV" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "lv-LV", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "lv-LV")
    expect(plural_keys).to eq([:zero, :one, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:zero)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:other)
    expect(rule.call(10)).to eq(:zero)
    expect(rule.call(11)).to eq(:zero)
    expect(rule.call(19)).to eq(:zero)
    expect(rule.call(20)).to eq(:zero)
    expect(rule.call(21)).to eq(:one)
    expect(rule.call(100)).to eq(:zero)
    expect(rule.call(111)).to eq(:zero)
  end
end
