require "i18n"
require "active_support"
require "active_support/core_ext/hash"

require "tmdb/i18n_delete"
require "tmdb/i18n_patch"

# This class is used to generate a "patch" for an i18n locale, which can be deep_merged into an
# existing translation to add missing keys without overwriting existing values and preserving
# pluralization keys per locale.
#
# NOTE: This assumes keys are strings.
class I18nRename
  attr_reader :old_key, :new_key

  def initialize(old_key:, new_key:)
    @old_key = old_key
    @new_key = new_key
  end

  def apply(target, delete_old_key: true)
    locale = target.keys.first

    source = {}
    locale_hash = (source[locale] ||= {})
    new_key.each.with_index.inject(locale_hash) do |iterator, (key, index)|
      iterator[key] = new_key[index + 1] ? (iterator[key] || {}) : target.dig(locale, *old_key)
      iterator[key] # rubocop:disable Lint/UnmodifiedReduceAccumulator
    end

    result = I18nPatch.new(source, locale: locale).apply(target)
    result = I18nDelete.new(delete_key: old_key).apply(result) if delete_old_key

    result
  end
end
