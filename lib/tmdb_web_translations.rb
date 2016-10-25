module TMDb
  module Config
    class I18n

      @@master_i18n_language_list = nil

      def self.default_iso_3166_1_mapping
        TMDb::Config::I18n.default_mapping.invert.merge('es-MX' => 'es',
                                                        'fr-CA' => 'fr',
                                                        'pt-BR' => 'pt',
                                                        'zh-TW' => 'zh')
      end

      def self.default_mapping
        { 'en' => 'en-US',
          'bg' => 'bg-BG',
          'bn' => 'bn-BD',
          'ca' => 'ca-ES',
          'ch' => 'ch-GU',
          'cs' => 'cs-CZ',
          'da' => 'da-DK',
          'de' => 'de-DE',
          'el' => 'el-GR',
          'es' => 'es-ES',
          'eu' => 'eu-ES',
          'fa' => 'fa-IR',
          'fi' => 'fi-FI',
          'fr' => 'fr-FR',
          'he' => 'he-IL',
          'hi' => 'hi-IN',
          'hu' => 'hu-HU',
          'id' => 'id-ID',
          'it' => 'it-IT',
          'ja' => 'ja-JP',
          'ka' => 'ka-GE',
          'ko' => 'ko-KR',
          'nb' => 'nb-NO',
          'nl' => 'nl-NL',
          'no' => 'no-NO',
          'pl' => 'pl-PL',
          'pt' => 'pt-PT',
          'ro' => 'ro-RO',
          'ru' => 'ru-RU',
          'sl' => 'sl-SI',
          'sr' => 'sr-RS',
          'sv' => 'sv-SE',
          'ta' => 'ta-IN',
          'th' => 'th-TH',
          'tr' => 'tr-TR',
          'uk' => 'uk-UA',
          'vi' => 'vi-VN',
          'zh' => 'zh-CN' }
      end

      def self.default_language_to_country_mapping
        TMDb::Config::I18n.default_mapping.map { |k,v| v.split('-') }.to_hash
      end

      def self.language_list
        return @@master_i18n_language_list unless @@master_i18n_language_list.nil?
        @@master_i18n_language_list = ((Language.distinct(:iso_639_1) - TMDb::Config::I18n.supported_iso_639_1).map { |iso_639_1| "#{iso_639_1}-#{iso_639_1.upcase}" } + TMDb::Config::I18n.default_iso_3166_1_mapping.keys).sort
      end

      def self.load_path
        File.dirname(__FILE__) + "/../locales"
      end

      def self.supported_iso_639_1
        TMDb::Config::I18n.default_mapping.keys
      end

    end
  end
end