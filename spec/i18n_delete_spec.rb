# frozen_string_literal: true
require "tmdb/i18n_delete"

RSpec.describe I18nDelete do
  describe "#apply" do
    example "deletes key and empty nested keys" do
      target = {
        "en-US" => {
          "meep" => {
            "moop" => "abc123"
          }
        }
      }

      result = described_class.new(delete_key: ["meep", "moop"]).apply(target)

      expect(result).to eq({
        "en-US" => { }
      })
    end

    example "remove old key and preserve other nested keys " do
      target = {
        "en-US" => {
          "meep" => {
            "moop" => "abc123",
            "zoop" => "xyz789"
          }
        }
      }

      result = described_class.new(delete_key: ["meep", "moop"]).apply(target)

      expect(result).to eq({
        "en-US" => {
          "meep" => {
            "zoop" => "xyz789"
          }
        }
      })
    end
  end
end
