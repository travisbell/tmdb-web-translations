module TMDb
  module Config
    class I18n

      def self.fallbacks
        { 'en' => 'en-US',
          'bg' => 'bg-BG',
          'bn' => 'bn-BD',
          'es' => 'es-ES',
          'fi' => 'fi-FI',
          'fr' => 'fr-FR',
          'ko' => 'ko-KR',
          'pt' => 'pt-PT',
          'sv' => 'sv-SE',
          'tr' => 'tr-TR',
          'zh' => 'zh-CN' }
      end

      def self.load_path
        File.dirname(__FILE__) + "/../locales"
      end

      def self.supported_iso_639_1
        [ 'en',
          'bg',
          'bn',
          'cs',
          'da',
          'de',
          'el',
          'es',
          'fi',
          'fr',
          'he',
          'hu',
          'id',
          'it',
          'ja',
          'ka',
          'ko',
          'nl',
          'no',
          'pl',
          'pt',
          'ro',
          'ru',
          'sl',
          'sr',
          'sv',
          'th',
          'tr',
          'uk',
          'zh' ]
      end

    end
  end
end