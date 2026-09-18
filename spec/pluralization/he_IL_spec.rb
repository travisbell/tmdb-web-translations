# frozen_string_literal: true

RSpec.describe "pluralization for he-IL" do
  subject(:rule) { I18n.t(:"i18n.plural.rule", locale: "he-IL", resolve: false) }

  it "has the correct plural keys" do
    plural_keys = I18n.t("i18n.plural.keys", locale: "he-IL")
    expect(plural_keys).to eq([:one, :two, :other])
  end

  it "returns the correct plural key for a count" do
    expect(rule.call(0)).to eq(:other)
    expect(rule.call(1)).to eq(:one)
    expect(rule.call(2)).to eq(:two)
    expect(rule.call(3)).to eq(:other)
    expect(rule.call(4)).to eq(:other)
  end
end
