# frozen_string_literal: true

RSpec.describe "count translation regressions" do
  {
    "th-TH" => "awards.nominations",
    "vi-VN" => "awards.nominations",
    "zh-TW" => "awards.wins",
    "zh-CN" => "number_of_results"
  }.each do |locale, key|
    example "interpolates #{key} in #{locale} for zero, one and multiple items" do
      [0, 1, 5, 1_000_000].each do |count|
        result = I18n.t(key, locale:, count:, raise: true)
        expect(result).to include(count.to_s)
        expect(result).not_to include("{count}")
      end
    end
  end
end
