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
          "many" => nil
        },
        "jkl" => [1, 2, 3]
      })
    end

    example "handle zero edge case when converting pluralized keys for en-US" do
      patch = I18nPatch.new(
        {
          "abc" => {
            "zero" => "789"
          }
        },
        locale: "en-US"
      )

      target = {
        "abc" => {
          "one" => "234",
          "other" => "456"
        }
      }

      expect(patch.apply(target)).to eq({
        "abc" => {
          "one" => "234",
          "other" => "456",
          "zero" => "789"
        }
      })
    end

    example "handle nested keys including plural keys, eg. other" do
      patch = I18nPatch.new(
        {
          "abc" => {
            "other" => "789"
          }
        },
        locale: "en-US"
      )

      target = {
        "abc" => {
          "this" => "123",
          "that" => "234"
        }
      }

      expect(patch.apply(target)).to eq({
        "abc" => {
          "this" => "123",
          "that" => "234",
          "other" => "789"
        }
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
    it "returns keys for ar-EG" do
      patch = I18nPatch.new(locale: "ar-EG")

      expect(patch.plural_keys).to eq(["zero", "one", "two", "few", "many", "other"])
    end

    it "returns keys for uk-UA" do
      patch = I18nPatch.new(locale: "uk-UA")

      expect(patch.plural_keys).to eq(["one", "few", "many"])
    end

    it "returns default keys for other languages" do
      patch = I18nPatch.new(locale: "xx-XX")

      expect(patch.plural_keys).to eq(["one", "other"])
    end
  end
end
