# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
# Used for Cornish, Inari Sami, Inuktitut, Lule Sami, Nama, Northern Sami,
# Sami Language, Skolt Sami, Southern Sami.

module Weblate
  module Pluralization
    module OneTwoOther
      def self.rule
        lambda do |n|
          case n
          when 1 then :one
          when 2 then :two
          else :other
          end
        end
      end

      def self.with_locale(locale)
        {
          locale => {
            "i18n": {
              plural: {
                keys: [:one, :two, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
