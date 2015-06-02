module TMDb
  module Config
    class I18n
      def self.load_path
        File.dirname(__FILE__) + "/../locales"
      end
    end
  end
end