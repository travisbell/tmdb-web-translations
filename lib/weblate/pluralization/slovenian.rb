# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Slovenian
      def self.rule
        lambda do |n|
          return :other unless n.is_a?(Numeric)

          case n % 100
          when 1 then :one
          when 2 then :two
          when 3, 4 then :few
          else :other
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
