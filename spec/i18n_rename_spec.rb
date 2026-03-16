# frozen_string_literal: true
require "tmdb/i18n_rename"

RSpec.describe I18nRename do
  describe "#apply" do
    example "rename a key in the target hash" do
      target = {
        "en-US" => {
          "meep" => {
            "moop" => "abc123"
          }
        }
      }

      result = described_class.new(old_key: ["meep", "moop"], new_key: ["beep", "boop"]).apply(target, delete_old_key: false)

      expect(result).to eq({
        "en-US" => {
          "meep" => {
            "moop" => "abc123"
          },
          "beep" => {
            "boop" => "abc123"
          }
        }
      })
    end

    example "remove old key" do
      target = {
        "en-US" => {
          "meep" => {
            "moop" => "abc123"
          }
        }
      }

      result = described_class.new(old_key: ["meep", "moop"], new_key: ["beep", "boop"]).apply(target)

      expect(result).to eq({
        "en-US" => {
          "beep" => {
            "boop" => "abc123"
          }
        }
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

      result = described_class.new(old_key: ["meep", "moop"], new_key: ["beep", "boop"]).apply(target)

      expect(result).to eq({
        "en-US" => {
          "meep" => {
            "zoop" => "xyz789"
          },
          "beep" => {
            "boop" => "abc123"
          }
        }
      })
    end
  end
end
