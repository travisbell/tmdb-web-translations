# frozen_string_literal: true

require "i18n/backend/fallbacks"

# I18n::Backend::Simple.send(:include, I18n::Backend::Cache)
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
I18n::Backend::Simple.include(I18n::Backend::Pluralization)

I18n.load_path += Dir[TMDb::Web::Translations.load_path + "/*.yml"]
I18n.load_path += Dir[TMDb::Web::Translations.country_path + "/*.yml"]
I18n.load_path += Dir[TMDb::Web::Translations.language_path + "/*.yml"]
I18n.load_path += Dir[TMDb::Web::Translations.ordinal_path + "/*.rb"]
I18n.load_path += Dir[TMDb::Web::Translations.ordinal_path + "/*.yml"]
I18n.load_path += Dir[TMDb::Web::Translations.pluralization_path + "/*.rb"]
I18n.load_path += Dir[TMDb::Web::Translations.pluralization_path + "/*.yml"]
I18n.load_path += Dir[TMDb::Web::Translations.transliteration_path + "/*.rb"]
I18n.load_path += Dir[TMDb::Web::Translations.transliteration_path + "/*.yml"]

# I18n.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)

I18n.available_locales = (
  TMDb::Web::Translations.default_iso_3166_1_mapping.keys +
  TMDb::Web::Translations.default_iso_3166_1_mapping.values +
  TMDb::Web::Translations.default_language_i18n.values +
  TMDb::Web::Translations.default_iso_3166_1_i18n.values
).uniq

I18n.default_locale = "en-US"
I18n.enforce_available_locales = true
I18n.fallbacks = [:"en-US"]

TMDb::Web::Translations.default_language_i18n.each do |k, v|
  I18n.fallbacks.map(k => [v, "en-US"])
end

TMDb::Web::Translations.default_iso_3166_1_i18n.each do |k, v|
  I18n.fallbacks.map(k => v)
end

TMDb::Web::Translations.default_iso_3166_1_mapping.each do |k, v|
  I18n.fallbacks.map(v => k)
end

# Monkey patching #transliterate to return an empty string if it's nil
module I18n
  module Backend
    module Transliterator
      class HashTransliterator
        def transliterate(string, replacement = nil)
          return "" unless string

          replacement ||= DEFAULT_REPLACEMENT_CHAR
          string.gsub(/[^\x00-\x7f]/u) do |char|
            approximations[char] || replacement
          end
        end
      end
    end
  end
end
