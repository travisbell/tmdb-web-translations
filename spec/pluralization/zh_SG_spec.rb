# frozen_string_literal: true

RSpec.describe "pluralization for zh-SG" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "zh-SG", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "zh-SG")
    expect(plural_keys).to eq([:other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:other)
    expect(rule.call(1)).to eq(:other)
    expect(rule.call(2)).to eq(:other)
    expect(rule.call(100)).to eq(:other)
  end
end
