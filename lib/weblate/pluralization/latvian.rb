# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Latvian
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          mod10 = n % 10
          mod100 = n % 100

          if mod10 == 0 || (mod100 >= 11 && mod100 <= 19)
            :zero
          elsif mod10 == 1 && mod100 != 11
            :one
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
                keys: [:zero, :one, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
