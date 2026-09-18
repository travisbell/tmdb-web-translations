# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
# It is the same as OneManyOther, except 0 is categorized as "one".
# Used for French, Portuguese (Brazilian).

module Weblate
  module Pluralization
    module ZeroOneManyOther
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          if n == 0 || n == 1
            :one
          elsif n != 0 && n % 1_000_000 == 0
            :many
          else
            :other
          end
        end
      end

      def self.with_locale(locale)
        {
          locale => {
            "i18n": {
              plural: {
                keys: [:one, :many, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
