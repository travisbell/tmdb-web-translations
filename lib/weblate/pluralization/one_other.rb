# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
# Used as "default" pluralization rule

module Weblate
  module Pluralization
    module OneOther
      def self.rule
        lambda { |n| n == 1 ? :one : :other }
      end

      def self.with_locale(locale)
        {
          locale => {
            "i18n": {
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
