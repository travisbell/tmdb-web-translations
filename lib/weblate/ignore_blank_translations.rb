# frozen_string_literal: true

module Weblate
  # Weblate export uses blank strings for missing translations, which interferes with
  # I18n::Backend::Fallbacks plugin. This converts "" -> nil so fallbacks work as expected.
  module IgnoreBlankTranslations
    def translate(locale, key, options = I18n::EMPTY_HASH)
      (result = super) == "" ? nil : result
    end
  end
end
