require "i18n"
require "active_support"
require "active_support/core_ext/hash"

# This class is used to generate a "patch" for an i18n locale, which can be deep_merged into an
# existing translation to add missing keys without overwriting existing values and preserving
# pluralization keys per locale.
#
# NOTE: This assumes keys are strings.
class I18nPatch
  PLURAL_KEYS = [
    "zero",
    "one",
    "two",
    "few",
    "many",
    "other"
  ]

  attr_reader :locale, :plural_keys, :source

  def initialize(source = {}, locale: I18n.default_locale)
    @source = source
    @locale = locale
    @plural_keys = I18n.t("i18n.plural.keys", locale: locale).map(&:to_s) || ["other"]
    @plural_hash = @plural_keys.each_with_object({}) { |key, hash| hash[key] = nil }
  end

  def apply(target, empty: false)
    patch = deep_transform_values(@source) { |value| empty ? nil : value }

    # This prioritizes values from the original target hash so key order is preserved.
    target.deep_merge(patch) { |_key, current_value, _new_value| current_value }
  end

  # NOTE: The existing deep_transform_values method from ActiveSupport only yields "leaf"
  # values, so it can't be used to transform hashes with plural keys.
  private def deep_transform_values(object, &block)
    case object
    when Hash
      if plural_keys?(object)
        @plural_hash.dup
      else
        object.transform_values { |value| deep_transform_values(value, &block) }
      end
    when Array
      object.map { |value| deep_transform_values(value, &block) }
    else
      yield(object)
    end
  end

  private def plural_keys?(object)
    (object.keys & PLURAL_KEYS).length >= 1
  end
end
