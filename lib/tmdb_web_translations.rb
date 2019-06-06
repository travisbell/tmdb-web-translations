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
        'cs' => 'cs-CZ',
        'da' => 'da-DK',
        'de' => 'de-DE',
        'el' => 'el-GR',
        'en' => 'en-US',
        'eo' => 'eo-EO',
        'es' => 'es-ES',
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
        'sr' => 'sr-RS',
        'sv' => 'sv-SE',
        'ta' => 'ta-IN',
        'te' => 'te-IN',
        'tl' => 'tl-PH',
        'th' => 'th-TH',
        'tr' => 'tr-TR',
        'uk' => 'uk-UA',
        'vi' => 'vi-VN',
        'zh' => 'zh-CN'
      }.freeze

      BLACKLISTED_TRANSLATIONS = [
        'en-AU',
        'en-CA',
        'en-GB'
      ].freeze

      @@default_language_to_i18n = nil
      @@default_language_to_country_mapping = nil
      @@master_i18n_language_list = nil
      @@supported_iso_639_1_path = nil

      def self.country_path
        File.dirname(__FILE__) + "/../countries"
      end

      def self.default_iso_3166_1_mapping
        @@default_iso_3166_1_mapping ||= TMDb::Config::I18n::DEFAULT_MAPPING.invert.merge!(
          'ar-AE' => 'ar',
          'en-AU' => 'en',
          'en-CA' => 'en',
          'en-GB' => 'en',
          'es-MX' => 'es',
          'fr-CA' => 'fr',
          'pt-BR' => 'pt',
          'zh-HK' => 'zh',
          'zh-TW' => 'zh'
        )
      end

      def self.default_iso_3166_1_i18n
        @@default_iso_3166_1_i18n ||= TMDb::Config::I18n.default_iso_3166_1_mapping.each_with_object({}) do |(i18n, iso_3166_1), hash|
          iso_3166_1 = i18n.split('-')[1]
          hash[iso_3166_1] = i18n unless hash[iso_3166_1]
        end
      end

      def self.default_language_i18n
        @@default_language_to_i18n ||= Language.distinct(:iso_639_1).each_with_object({}) { |iso_639_1, hash|
          hash[iso_639_1] = "#{iso_639_1}-#{iso_639_1.upcase}"
        }.merge!(TMDb::Config::I18n::DEFAULT_MAPPING)
      end

      def self.default_language_to_country_mapping
        @@default_language_to_country_mapping ||= Hash[TMDb::Config::I18n::DEFAULT_MAPPING.map { |k,v| v.split('-') }]
      end

      def self.language_list
        return @@master_i18n_language_list unless @@master_i18n_language_list.nil?

        master_i18n_language_list = (Language.distinct(:iso_639_1) - TMDb::Config::I18n.supported_iso_639_1).each_with_object({}) do |iso_639_1, hash|
          hash["#{iso_639_1}-#{iso_639_1.upcase}"] = "#{iso_639_1}"
        end.merge!(TMDb::Config::I18n.default_iso_3166_1_mapping).sort_by { |h,v| v }

        @@master_i18n_language_list = Hash[master_i18n_language_list]
      end

      def self.language_path
        File.dirname(__FILE__) + "/../languages"
      end

      def self.load_path
        File.dirname(__FILE__) + "/../locales"
      end

      def self.parse_valid_i18n(valid_i18n)
        split_18n = valid_i18n.split('-')
        [valid_i18n, split_18n[0], split_18n[1]]
      end

      def self.supported_iso_639_1
        TMDb::Config::I18n::DEFAULT_MAPPING.keys
      end

      def self.supported_iso_639_1_path
        @@supported_iso_639_1_path ||= TMDb::Config::I18n.supported_iso_639_1.map { |iso| "/#{iso}" }
      end

      def self.transliteration_path
        File.dirname(__FILE__) + "/../transliteration"
      end

    end
  end
end