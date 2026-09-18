# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
# Used for Czech, Slovak.

module Weblate
  module Pluralization
    module WestSlavic
      def self.rule
        lambda do |n|
          case n
          when 1 then :one
          when 2, 3, 4 then :few
          else :many
          end
        end
      end

      def self.with_locale(locale)
        {
          locale => {
            "i18n": {
              plural: {
                keys: [:one, :few, :many],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
