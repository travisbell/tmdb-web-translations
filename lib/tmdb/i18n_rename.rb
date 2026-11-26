# frozen_string_literal: true

require "active_support/core_ext/object/deep_dup"

require "tmdb/i18n_delete"

# Move or copy a translation subtree without converting its plural values to
# empty translation slots. Refuse collisions rather than discarding data.
#
# NOTE: This assumes keys are strings.
class I18nRename
  attr_reader :old_key, :new_key

  def initialize(old_key:, new_key:)
    [old_key, new_key].each do |path|
      unless path.is_a?(Array) && !path.empty? && path.all? { |key| key.is_a?(String) && !key.empty? }
        raise ArgumentError, "key paths must be non-empty arrays of strings"
      end
    end
    @old_key = old_key
    @new_key = new_key
  end

  def apply(target, delete_old_key: true)
    return target.deep_dup if old_key == new_key

    if old_key[0...new_key.length] == new_key || new_key[0...old_key.length] == old_key
      raise ArgumentError, "source and destination paths must not overlap"
    end
    locale = target.keys.first
    source = target[locale]
    old_key.each do |key|
      return target.deep_dup unless source.is_a?(Hash) && source.key?(key)

      source = source[key]
    end
    result = target.deep_dup
    destination = result[locale]
    new_key[0...-1].each do |key|
      if destination.key?(key) && !destination[key].is_a?(Hash)
        raise ArgumentError, "destination parent #{key.inspect} is not a mapping"
      end
      destination = (destination[key] ||= {})
    end
    if destination.key?(new_key.last)
      raise ArgumentError, "destination #{new_key.join('.').inspect} already exists"
    end
    destination[new_key.last] = source.deep_dup
    result = I18nDelete.new(delete_key: old_key).apply(result) if delete_old_key

    result
  end
end
