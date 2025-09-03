# frozen_string_literal: true

require "spec_helper"
require "tmdb/i18n_patch"

RSpec.describe I18nPatch do
  describe "#apply" do
    example "merging values" do
      patch = I18nPatch.new({
        "meep" => "123",
        "def" => {
          "ghi" => "234",
          "moop" => "456"
        }
      })

      target = {
        "abc" => "123",
        "def" => {
          "ghi" => "234"
        },
        "jkl" => [1, 2, 3],
        "xyz" => "345"
      }

      expect(patch.apply(target)).to eq({
        "abc" => "123",
        "def" => {
          "ghi" => "234",
          "moop" => "456"
        },
        "jkl" => [1, 2, 3],
        "xyz" => "345",
        "meep" => "123"
      })
    end

    example "converting pluralized keys" do
      patch = I18nPatch.new(
        {
          "def" => {
            "one" => "234",
            "other" => "456"
          }
        },
        locale: "lt-LT"
      )

      target = {
        "abc" => "123",
        "jkl" => [1, 2, 3]
      }

      expect(patch.apply(target)).to eq({
        "abc" => "123",
        "def" => {
          "one" => nil,
          "few" => nil,
          "other" => nil
        },
        "jkl" => [1, 2, 3]
      })
    end

    example "prioritizes key order of target hash" do
      patch = I18nPatch.new({
        "ghi" => "345",
        "jkl" => "456"
      })

      target = {
        "abc" => "123",
        "def" => "234"
      }

      expect(patch.apply(target).keys).to eq(["abc", "def", "ghi", "jkl"])
    end
  end

  describe "#locale" do
    it "returns the default I18n locale" do
      patch = I18nPatch.new

      expect(patch.locale).to eq(I18n.default_locale)
    end

    it "returns the specified locale" do
      patch = I18nPatch.new(locale: "ar-EG")

      expect(patch.locale).to eq("ar-EG")
    end
  end

  describe "#plural_keys" do
    it "returns a default" do
      patch = I18nPatch.new(locale: "xx-XX")

      expect(patch.plural_keys).to eq(["one", "other"])
    end

    it "returns the specified locale" do
      patch = I18nPatch.new(locale: "ar-EG")

      expect(patch.plural_keys).to eq(["zero", "one", "two", "few", "many", "other"])
    end
  end
end
