# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Arabic
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          mod100 = n % 100

          if n == 0
            :zero
          elsif n == 1
            :one
          elsif n == 2
            :two
          elsif (3..10).to_a.include?(mod100)
            :few
          elsif (11..99).to_a.include?(mod100)
            :many
          else
            :other
          end
        end
      end

      def self.with_locale(locale)
        {
          locale => {
            i18n: {
              plural: {
                keys: [:zero, :one, :two, :few, :many, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
