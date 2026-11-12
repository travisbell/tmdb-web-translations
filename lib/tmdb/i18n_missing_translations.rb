# frozen_string_literal: true

class I18nMissingTranslations
  PLURAL_KEYS = %w[zero one two few many other].freeze

  class << self
    # Traverse source text and use the target locale's plural categories.
    # A missing target-only category uses the source's other text as context.
    # Source zero text remains available as an optional I18n zero override.
    def find(source, target, path = [], results = [], plural_keys: nil)
      case source
      when Hash
        plural = plural_keys && (source.keys & PLURAL_KEYS).length >= 2
        source.each do |key, value|
          next if plural && PLURAL_KEYS.include?(key) && !plural_keys.include?(key) && key != "zero"

          translated = target.is_a?(Hash) ? target[key] : nil
          find(value, translated, path + [key], results, plural_keys: plural_keys)
        end
        if plural && source["other"].is_a?(String)
          (plural_keys - source.keys).each do |key|
            translated = target.is_a?(Hash) ? target[key] : nil
            find(source["other"], translated, path + [key], results, plural_keys: plural_keys)
          end
        end
      when Array
        source.each_with_index do |value, index|
          translated = target.is_a?(Array) ? target[index] : nil
          find(value, translated, path + [index], results, plural_keys: plural_keys)
        end
      when String
        # Human-readable unit labels are text; separators, precision, currency
        # symbols and format templates remain configuration.
        unit_label = path[0, 2] == %w[number human] && path[3] == "units"
        return results if path.first == "number" && !unit_label
        return results if blank?(source)

        results << [path, source] if target.nil? || (target.is_a?(String) && blank?(target))
      end
      results
    end

    private

    def blank?(text)
      text.match?(/\A[[:space:]\p{Cf}]*\z/)
    end
  end
end
