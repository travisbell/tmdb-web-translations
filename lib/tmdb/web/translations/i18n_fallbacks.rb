# encoding: utf-8
# frozen_string_literal: true

require 'i18n/backend/fallbacks'

# I18n::Backend::Simple.send(:include, I18n::Backend::Cache)
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.load_path += Dir[TMDb::Config::I18n.load_path + '/*.yml']
I18n.load_path += Dir[TMDb::Config::I18n.country_path + '/*.yml']
I18n.load_path += Dir[TMDb::Config::I18n.language_path + '/*.yml']
I18n.load_path += Dir[TMDb::Config::I18n.transliteration_path + '/*.rb']
I18n.load_path += Dir[TMDb::Config::I18n.transliteration_path + '/*.yml']

# I18n.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)
I18n.enforce_available_locales = false
I18n.default_locale = 'en-US'

TMDb::Config::I18n.default_iso_3166_1_mapping.each do |k, _v|
  I18n.fallbacks.map(k.downcase => [k])
end

TMDb::Config::I18n.default_language_i18n.each do |k, v|
  I18n.fallbacks.map(k => [v, "en-US"])
end

# Monkey patching #transliterate to return an empty string if it's nil
module I18n
  module Backend
    module Transliterator
      class HashTransliterator
        def transliterate(string, replacement = nil)
          return '' unless string
          replacement ||= DEFAULT_REPLACEMENT_CHAR
          string.gsub(/[^\x00-\x7f]/u) do |char|
            approximations[char] || replacement
          end
        end
      end
    end
  end
end
