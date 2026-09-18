# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Macedonian
      def self.rule
        lambda do |n|
          if n.is_a?(Numeric) && n % 10 == 1 && n != 11
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
                keys: [:one, :other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
