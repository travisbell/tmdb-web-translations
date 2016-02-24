module TMDb
  module Config
    class I18n

      def self.default_mapping
        { 'en' => 'en-US',
          'bg' => 'bg-BG',
          'bn' => 'bn-BD',
          'cs' => 'cs-CZ',
          'da' => 'da-DK',
          'de' => 'de-DE',
          'el' => 'el-GR',
          'es' => 'es-ES',
          'fi' => 'fi-FI',
          'fr' => 'fr-FR',
          'he' => 'he-IL',
          'hu' => 'hu-HU',
          'id' => 'id-ID',
          'it' => 'it-IT',
          'ja' => 'ja-JP',
          'ka' => 'ka-GE',
          'ko' => 'ko-KR',
          'nl' => 'nl-NL',
          'no' => 'no-NO',
          'pl' => 'pl-PL',
          'pt' => 'pt-PT',
          'ro' => 'ro-RO',
          'ru' => 'ru-RU',
          'sl' => 'sl-SI',
          'sr' => 'sr-RS',
          'sv' => 'sv-SE',
          'th' => 'th-TH',
          'tr' => 'tr-TR',
          'uk' => 'uk-UA',
          'zh' => 'zh-CN' }
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