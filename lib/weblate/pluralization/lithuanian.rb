# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Lithuanian
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          mod10 = n % 10
          mod100 = n % 100

          if mod10 == 1 && !(11..19).to_a.include?(mod100)
            :one
          elsif (2..9).to_a.include?(mod10) && !(11..19).to_a.include?(mod100)
            :few
          else
            :many
          end
        end
      end

      def self.with_locale(locale)
        {
          locale => {
            i18n: {
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
