# encoding: utf-8
# frozen_string_literal: true

module TMDb
  module Config
    class I18n

      DEFAULT_MAPPING = {
        'ar' => 'ar-SA',
        'be' => 'be-BY',
        'bg' => 'bg-BG',
        'bn' => 'bn-BD',
        'ca' => 'ca-ES',
        'ch' => 'ch-GU',
        'cn' => 'cn-CN',
        'cs' => 'cs-CZ',
        'da' => 'da-DK',
        'de' => 'de-DE',
        'el' => 'el-GR',
        'en' => 'en-US',
        'eo' => 'eo-EO',
        'es' => 'es-ES',
        'et' => 'et-EE',
        'eu' => 'eu-ES',
        'fa' => 'fa-IR',
        'fi' => 'fi-FI',
        'fr' => 'fr-FR',
        'gl' => 'gl-ES',
        'he' => 'he-IL',
        'hi' => 'hi-IN',
        'hu' => 'hu-HU',
        'id' => 'id-ID',
        'it' => 'it-IT',
        'ja' => 'ja-JP',
        'ka' => 'ka-GE',
        'kk' => 'kk-KZ',
        'kn' => 'kn-IN',
        'ko' => 'ko-KR',
        'lt' => 'lt-LT',
        'lv' => 'lv-LV',
        'ml' => 'ml-IN',
        'ms' => 'ms-MY',
        'nb' => 'nb-NO',
        'nl' => 'nl-NL',
        'no' => 'no-NO',
        'pl' => 'pl-PL',
        'pt' => 'pt-PT',
        'ro' => 'ro-RO',
        'ru' => 'ru-RU',
        'si' => 'si-LK',
        'sk' => 'sk-SK',
        'sl' => 'sl-SI',
        'sq' => 'sq-AL',
        'sr' => 'sr-RS',
        'sv' => 'sv-SE',
        'ta' => 'ta-IN',
        'te' => 'te-IN',
        'tl' => 'tl-PH',
        'th' => 'th-TH',
        'tr' => 'tr-TR',
        'uk' => 'uk-UA',
        'vi' => 'vi-VN',
        'zh' => 'zh-CN',
        'zu' => 'zu-ZA'
      }.freeze

      IGNORED_TRANSLATIONS = [
        'en-AU',
        'en-CA',
        'en-GB',
        'en-IE',
        'en-NZ'
      ].freeze

      def self.country_path
        File.dirname(__FILE__) + "/../../../../countries"
      end

      def self.default_iso_3166_1_mapping
        @default_iso_3166_1_mapping ||= TMDb::Config::I18n::DEFAULT_MAPPING.invert.merge!(
          'ar-AE' => 'ar',
          'de-AT' => 'de',
          'de-CH' => 'de',
          'en-AU' => 'en',
          'en-CA' => 'en',
          'en-GB' => 'en',
          'en-IE' => 'en',
          'en-NZ' => 'en',
          'es-MX' => 'es',
          'fr-CA' => 'fr',
          'ms-SG' => 'ms',
          'pt-BR' => 'pt',
          'zh-HK' => 'zh',
          'zh-TW' => 'zh'
        ).freeze
      end

      def self.default_iso_3166_1_mapping_lowercase
        @default_iso_3166_1_mapping_lowercase ||= TMDb::Config::I18n.default_iso_3166_1_mapping.each_with_object({}) do |(i18n, iso_3166_1), hash|
          hash[i18n.downcase] = i18n
        end.freeze
      end

      def self.valid_i18n_translations
        @valid_i18n_translations ||= TMDb::Config::I18n.language_list.dup.delete_if { |k,v| TMDb::Config::I18n::IGNORED_TRANSLATIONS.include?(k) }.freeze
      end

      def self.default_iso_3166_1_i18n
        @default_iso_3166_1_i18n ||= TMDb::Config::I18n.language_list.each_with_object({}) do |(i18n, iso_3166_1), hash|
          iso_3166_1 = i18n.split('-')[1]
          hash[iso_3166_1] = i18n unless hash[iso_3166_1]
        end.freeze
      end

      def self.default_language_i18n
        @default_language_i18n ||= Language.distinct(:iso_639_1).each_with_object({}) { |iso_639_1, hash|
          hash[iso_639_1] = "#{iso_639_1}-#{iso_639_1.upcase}"
        }.merge!(TMDb::Config::I18n::DEFAULT_MAPPING).freeze
      end

      def self.default_language_to_country_mapping
        @default_language_to_country_mapping ||= Hash[TMDb::Config::I18n::DEFAULT_MAPPING.map { |k,v| v.split('-') }].freeze
      end

      def self.language_list
        @language_list ||= (Language.distinct(:iso_639_1) - TMDb::Config::I18n.supported_iso_639_1).each_with_object({}) do |iso_639_1, hash|
          hash["#{iso_639_1}-#{iso_639_1.upcase}"] = "#{iso_639_1}"
        end.merge!(TMDb::Config::I18n.default_iso_3166_1_mapping).sort_by { |h,v| v }.to_h.freeze
      end

      def self.language_path
        File.dirname(__FILE__) + "/../../../../languages"
      end

      def self.load_path
        File.dirname(__FILE__) + "/../../../../locales"
      end

      def self.parse_valid_i18n(string)
        return ['en-US', 'en', 'US'] if (string.nil? || string == '')

        begin
          split_string = string.split('-')
          [string, split_string[0], split_string[1]]
        rescue
          ['en-US', 'en', 'US']
        end
      end

      def self.supported_iso_639_1
        TMDb::Config::I18n::DEFAULT_MAPPING.keys
      end

      def self.supported_iso_639_1_path
        @supported_iso_639_1_path ||= TMDb::Config::I18n.supported_iso_639_1.map { |iso| "/#{iso}" }.freeze
      end

      def self.transliteration_path
        File.dirname(__FILE__) + "/../../../../transliteration"
      end

    end
  end
end