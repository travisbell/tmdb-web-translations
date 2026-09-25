# frozen_string_literal: true

module Weblate
  # Weblate exports every value as a string (and some get translated, e.g. "錯誤"), but
  # ActiveSupport::NumberHelper needs real booleans/integers. Unparseable values are dropped
  # so ActiveSupport's defaults apply.
  module TypedNumberFormats
    BOOLEAN_OPTIONS = ["significant", "strip_insignificant_zeros"].freeze
    BOOLEANS = { "true" => true, "false" => false }.freeze

    class << self
      def coerce(hash)
        hash.each_with_object({}) do |(key, value), result|
          if value.is_a?(Hash)
            result[key] = coerce(value)
          elsif BOOLEAN_OPTIONS.include?(key.to_s)
            boolean = BOOLEANS[value.to_s.downcase]
            result[key] = boolean unless boolean.nil?
          elsif key.to_s == "precision"
            result[key] = value.to_s.to_i if value.to_s.match?(/\A\d+\z/)
          else
            result[key] = value
          end
        end
      end
    end

    def store_translations(locale, data, options = I18n::EMPTY_HASH)
      key = [:number, "number"].find { |k| data[k].is_a?(Hash) }
      data = data.merge(key => TypedNumberFormats.coerce(data[key])) if key
      super
    end
  end
end
