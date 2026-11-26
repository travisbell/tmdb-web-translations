# frozen_string_literal: true

require "yaml"

RSpec.describe "ISO code YAML regressions" do
  [["pt-PT", "countries.NO"], ["pt-PT", "languages.no"], ["he-IL", "languages.no"]].each do |locale, key|
    example "loads #{key} as a string key in #{locale} without using a fallback" do
      component = key.split(".").first
      data = YAML.safe_load_file(File.expand_path("../#{component}/#{locale}.yml", __dir__))[locale]
      value = data.dig(*key.split("."))
      expect(value).to be_a(String)
      expect(value.strip).not_to be_empty
      expect(I18n.t(key, locale:, raise: true)).to eq(value)
    end
  end
end
