# frozen_string_literal: true

require "spec_helper"

RSpec.describe TMDb::Web::Translations do
  describe ".parse_valid_i18n" do
    it "parses a full locale" do
      expect(described_class.parse_valid_i18n("en-US")).to eq(["en-US", "en", "US"])
    end

    it "parses a language-only code" do
      expect(described_class.parse_valid_i18n("en")).to eq(["en-EN", "en", "EN"])
    end

    it "returns the default for nil" do
      expect(described_class.parse_valid_i18n(nil)).to eq(["en-US", "en", "US"])
    end

    it "returns the default for an empty string" do
      expect(described_class.parse_valid_i18n("")).to eq(["en-US", "en", "US"])
    end

    it "returns the default for a bare dash" do
      expect(described_class.parse_valid_i18n("-")).to eq(["en-US", "en", "US"])
    end

    it "returns the default for a leading-dash value" do
      expect(described_class.parse_valid_i18n("-US")).to eq(["en-US", "en", "US"])
    end
  end
end
