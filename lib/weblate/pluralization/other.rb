# frozen_string_literal: true

# This was adapted from rails-i18n to match CLDR+ rules used by Weblate.
module Weblate
  module Pluralization
    module Other
      def self.rule
        proc { :other }
      end

      def self.with_locale(locale)
        {
          locale => {
            "i18n": {
              plural: {
                keys: [:other],
                rule: rule
              }
            }
          }
        }
      end
    end
  end
end
