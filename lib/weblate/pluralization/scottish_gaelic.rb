# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module ScottishGaelic
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          floorn = n.floor

          if floorn == 1 || floorn == 11
            :one
          elsif floorn == 2 || floorn == 12
            :two
          elsif (3..19).member?(floorn)
            :few
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
                keys: [:one, :two, :few, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
