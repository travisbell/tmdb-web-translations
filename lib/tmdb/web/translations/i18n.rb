# encoding: utf-8
# frozen_string_literal: true

module TMDb
  module Web
    class Translations

      DEFAULT_MAPPING = {
        'af' => 'af-ZA', 'ar' => 'ar-SA', 'be' => 'be-BY', 'bg' => 'bg-BG', 'bn' => 'bn-BD', 'br' => 'br-FR',
        'ca' => 'ca-ES', 'ch' => 'ch-GU', 'cs' => 'cs-CZ', 'cy' => 'cy-GB', 'da' => 'da-DK', 'de' => 'de-DE',
        'el' => 'el-GR', 'en' => 'en-US', 'eo' => 'eo-EO', 'es' => 'es-ES', 'et' => 'et-EE', 'eu' => 'eu-ES',
        'fa' => 'fa-IR', 'fi' => 'fi-FI', 'fr' => 'fr-FR', 'ga' => 'ga-IE', 'gd' => 'gd-GB', 'gl' => 'gl-ES',
        'he' => 'he-IL', 'hi' => 'hi-IN', 'hr' => 'hr-HR', 'hu' => 'hu-HU', 'id' => 'id-ID', 'it' => 'it-IT',
        'ja' => 'ja-JP', 'ka' => 'ka-GE', 'kk' => 'kk-KZ', 'kn' => 'kn-IN', 'ko' => 'ko-KR', 'ky' => 'ky-KG',
        'lt' => 'lt-LT', 'lv' => 'lv-LV', 'ml' => 'ml-IN', 'mr' => 'mr-IN', 'ms' => 'ms-MY', 'nb' => 'nb-NO',
        'nl' => 'nl-NL', 'no' => 'no-NO', 'pa' => 'pa-IN', 'pl' => 'pl-PL', 'pt' => 'pt-PT', 'ro' => 'ro-RO',
        'ru' => 'ru-RU', 'si' => 'si-LK', 'sk' => 'sk-SK', 'sl' => 'sl-SI', 'sq' => 'sq-AL', 'sr' => 'sr-RS',
        'sv' => 'sv-SE', 'sw' => 'sw-TZ', 'ta' => 'ta-IN', 'te' => 'te-IN', 'tl' => 'tl-PH', 'th' => 'th-TH',
        'tr' => 'tr-TR', 'uk' => 'uk-UA', 'ur' => 'ur-PK', 'vi' => 'vi-VN', 'zh' => 'zh-CN', 'zu' => 'zu-ZA'
      }.freeze

      DEFAULT_COUNTRY_MAPPING = {
        "AA"=>"aa-AA", "AB"=>"ab-AB", "AE"=>"ae-AE", "ZA"=>"af-ZA", "AK"=>"ak-AK", "AM"=>"am-AM", "AN"=>"an-AN",
        "TD"=>"ar-TD", "SA"=>"ar-SA", "BH"=>"ar-BH", "EG"=>"ar-EG", "IQ"=>"ar-IQ", "JO"=>"ar-JO", "LY"=>"ar-LY",
        "MA"=>"ar-MA", "QA"=>"ar-QA", "YE"=>"ar-YE", "AS"=>"as-AS", "AV"=>"av-AV", "AY"=>"ay-AY", "AZ"=>"az-AZ",
        "BA"=>"ba-BA", "BY"=>"be-BY", "BG"=>"bg-BG", "BI"=>"bi-BI", "BM"=>"bm-BM", "BD"=>"bn-BD", "BO"=>"bo-BO",
        "FR"=>"fr-FR", "BS"=>"bs-BS", "AD"=>"ca-AD", "ES"=>"es-ES", "CE"=>"ce-CE", "GU"=>"ch-GU", "CO"=>"co-CO",
        "CR"=>"cr-CR", "CZ"=>"cs-CZ", "CU"=>"cu-CU", "CV"=>"cv-CV", "GB"=>"en-GB", "DK"=>"da-DK", "CH"=>"de-CH",
        "DE"=>"de-DE", "AT"=>"de-AT", "DV"=>"dv-DV", "DZ"=>"dz-DZ", "EE"=>"ee-EE", "GR"=>"el-GR", "CY"=>"el-CY",
        "KE"=>"en-KE", "ZW"=>"en-ZW", "ZM"=>"en-ZM", "TC"=>"en-TC", "PG"=>"en-PG", "NZ"=>"en-NZ", "MW"=>"en-MW",
        "LC"=>"en-LC", "JM"=>"en-JM", "IE"=>"en-IE", "GY"=>"en-GY", "GI"=>"en-GI", "GH"=>"en-GH", "GG"=>"en-GG",
        "CM"=>"en-CM", "CA"=>"en-CA", "BZ"=>"en-BZ", "BB"=>"en-BB", "AU"=>"en-AU", "AG"=>"en-AG", "US"=>"en-US",
        "EO"=>"eo-EO", "CL"=>"es-CL", "GQ"=>"es-GQ", "GT"=>"es-GT", "EC"=>"es-EC", "DO"=>"es-DO", "HN"=>"es-HN",
        "MX"=>"es-MX", "NI"=>"es-NI", "PA"=>"es-PA", "UY"=>"es-UY", "AR"=>"es-AR", "PE"=>"es-PE", "PY"=>"es-PY",
        "SV"=>"es-SV", "IR"=>"fa-IR", "FF"=>"ff-FF", "FI"=>"fi-FI", "FJ"=>"fj-FJ", "FO"=>"fo-FO", "CI"=>"fr-CI",
        "GP"=>"fr-GP", "MC"=>"fr-MC", "ML"=>"fr-ML", "MU"=>"fr-MU", "PF"=>"fr-PF", "BF"=>"fr-BF", "CD"=>"fr-CD",
        "GF"=>"fr-GF", "FY"=>"fy-FY", "GN"=>"gn-GN", "GV"=>"gv-GV", "HA"=>"ha-HA", "IL"=>"he-IL", "IN"=>"hi-IN",
        "HO"=>"ho-HO", "HR"=>"hr-HR", "HT"=>"ht-HT", "HU"=>"hu-HU", "HY"=>"hy-HY", "HZ"=>"hz-HZ", "IA"=>"ia-IA",
        "ID"=>"id-ID", "IG"=>"ig-IG", "II"=>"ii-II", "IK"=>"ik-IK", "IO"=>"io-IO", "IS"=>"is-IS", "VA"=>"it-VA",
        "IT"=>"it-IT", "IU"=>"iu-IU", "JP"=>"ja-JP", "JV"=>"jv-JV", "GE"=>"ka-GE", "KG"=>"kg-KG", "KI"=>"ki-KI",
        "KJ"=>"kj-KJ", "KZ"=>"kk-KZ", "KL"=>"kl-KL", "KM"=>"km-KM", "KR"=>"ko-KR", "KS"=>"ks-KS", "KU"=>"ku-KU",
        "KV"=>"kv-KV", "KW"=>"kw-KW", "LA"=>"la-LA", "LB"=>"lb-LB", "LG"=>"lg-LG", "LI"=>"li-LI", "LN"=>"ln-LN",
        "LO"=>"lo-LO", "LT"=>"lt-LT", "LU"=>"lu-LU", "LV"=>"lv-LV", "MG"=>"mg-MG", "MH"=>"mh-MH", "MI"=>"mi-MI",
        "MK"=>"mk-MK", "MN"=>"mn-MN", "MO"=>"mo-MO", "SG"=>"ms-SG", "MY"=>"ms-MY", "MT"=>"mt-MT", "NA"=>"na-NA",
        "NO"=>"nb-NO", "ND"=>"nd-ND", "NE"=>"ne-NE", "NG"=>"ng-NG", "NL"=>"nl-NL", "BE"=>"nl-BE", "NN"=>"nn-NN",
        "NR"=>"nr-NR", "NV"=>"nv-NV", "NY"=>"ny-NY", "OC"=>"oc-OC", "OJ"=>"oj-OJ", "OM"=>"om-OM", "OR"=>"or-OR",
        "OS"=>"os-OS", "PI"=>"pi-PI", "PL"=>"pl-PL", "PS"=>"ps-PS", "AO"=>"pt-AO", "BR"=>"pt-BR", "PT"=>"pt-PT",
        "MZ"=>"pt-MZ", "QU"=>"qu-QU", "RM"=>"rm-RM", "RN"=>"rn-RN", "MD"=>"ro-MD", "RO"=>"ro-RO", "RU"=>"ru-RU",
        "RW"=>"rw-RW", "SC"=>"sc-SC", "SD"=>"sd-SD", "SE"=>"se-SE", "SH"=>"sh-SH", "LK"=>"si-LK", "SK"=>"sk-SK",
        "SI"=>"sl-SI", "SM"=>"sm-SM", "SN"=>"sn-SN", "SO"=>"so-SO", "XK"=>"sq-XK", "AL"=>"sq-AL", "RS"=>"sr-RS",
        "ME"=>"sr-ME", "SS"=>"ss-SS", "ST"=>"st-ST", "SU"=>"su-SU", "TZ"=>"sw-TZ", "TG"=>"tg-TG", "TH"=>"th-TH",
        "TI"=>"ti-TI", "TK"=>"tk-TK", "PH"=>"tl-PH", "TN"=>"tn-TN", "TO"=>"to-TO", "TR"=>"tr-TR", "TS"=>"ts-TS",
        "TT"=>"tt-TT", "TW"=>"tw-TW", "TY"=>"ty-TY", "UG"=>"ug-UG", "UA"=>"uk-UA", "PK"=>"ur-PK", "UZ"=>"uz-UZ",
        "VE"=>"ve-VE", "VN"=>"vi-VN", "VO"=>"vo-VO", "WA"=>"wa-WA", "WO"=>"wo-WO", "XH"=>"xh-XH", "XX"=>"xx-XX",
        "YI"=>"yi-YI", "YO"=>"yo-YO", "CN"=>"zh-CN", "HK"=>"zh-HK"
      }.freeze

      IGNORED_TRANSLATIONS = [
        'ar-BH', 'ar-EG', 'ar-IQ', 'ar-JO', 'ar-LY', 'ar-MA', 'ar-QA', 'ar-YE', 'ar-TD', 'br-FR', 'ca-AD',
        'en-AG', 'el-CY', 'en-AG', 'en-AU', 'en-BB', 'en-BZ', 'en-CA', 'en-CM', 'en-GB', 'en-GG',
        'en-GH', 'en-GI', 'en-GY', 'en-IE', 'en-JM', 'en-KE', 'en-LC', 'en-MW', 'en-NZ', 'en-PG',
        'en-TC', 'en-ZM', 'en-ZW', 'es-AR', 'es-CL', 'es-DO', 'es-EC', 'es-GT', 'es-GQ', 'es-HN',
        'es-NI', 'es-PA', 'es-PE', 'es-PY', 'es-SV', 'es-UY', 'fr-BF', 'fr-CD', 'fr-CI', 'fr-GF',
        'fr-GP', 'fr-MC', 'fr-ML', 'fr-MU', 'fr-PF', 'it-VA', 'pt-AO', 'pt-MZ', 'ro-MD', 'sr-ME',
        'sq-XK'
      ].freeze

      # This list is based on LANGUAGE_CODES, it contains all assigned ISO-369-1
      # codes, some deprecated codes and the unused xx code as "no-value".
      # https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
      LANGUAGE_CODES = %w[
        aa ab ae af ak am an ar as av ay az ba be bg bi bm bn bo br bs ca ce ch co cr cs cu
        cv cy da de dv dz ee el en eo es et eu fa ff fi fj fo fr fy ga gd gl gn gu gv ha he hi
        ho hr ht hu hy hz ia id ie ig ii ik io is it iu ja jv ka kg ki kj kk kl km kn ko kr ks
        ku kv kw ky la lb lg li ln lo lt lu lv mg mh mi mk ml mn mo mr ms mt my na nb nd ne ng
        nl nn no nr nv ny oc oj om or os pa pi pl ps pt qu rm rn ro ru rw sa sc sd se sg sh si
        sk sl sm sn so sq sr ss st su sv sw ta te tg th ti tk tl tn to tr ts tt tw ty ug uk ur
        uz ve vi vo wa wo xh xx yi yo za zh zu
      ].freeze

      # This list contains ISO-369-1 codes whose text direction is right to left.
      # The list is incomplete and only includes RTL translations that TMDB currently supports.
      # This list should be updated to include new RTL translations that TMDB supports.
      # https://localizely.com/iso-639-1-list/
      RTL_LANGUAGE_CODES = [
        "ar",
        "fa",
        "he"
      ].freeze

      def self.country_path
        File.dirname(__FILE__) + "/../../../../countries"
      end

      def self.default_iso_3166_1_mapping
        @default_iso_3166_1_mapping ||= DEFAULT_MAPPING.invert.merge(
          'ar-AE' => 'ar', 'ar-BH' => 'ar', 'ar-EG' => 'ar', 'ar-IQ' => 'ar', 'ar-JO' => 'ar', 'ar-LY' => 'ar',
          'ar-MA' => 'ar', 'ar-QA' => 'ar', 'ar-YE' => 'ar', 'ar-TD' => 'ar', 'ca-AD' => 'ca', 'de-AT' => 'de',
          'de-CH' => 'de', 'el-CY' => 'el', 'en-AG' => 'en', 'en-AU' => 'en', 'en-BB' => 'en', 'en-BZ' => 'en',
          'en-CA' => 'en', 'en-CM' => 'en', 'en-GB' => 'en', 'en-GG' => 'en', 'en-GH' => 'en', 'en-GI' => 'en',
          'en-GY' => 'en', 'en-IE' => 'en', 'en-JM' => 'en', 'en-KE' => 'en', 'en-LC' => 'en', 'en-MW' => 'en',
          'en-NZ' => 'en', 'en-PG' => 'en', 'en-TC' => 'en', 'en-ZM' => 'en', 'en-ZW' => 'en', 'es-AR' => 'es',
          'es-CL' => 'es', 'es-DO' => 'es', 'es-EC' => 'es', 'es-GT' => 'es', 'es-GQ' => 'es', 'es-HN' => 'es',
          'es-MX' => 'es', 'es-NI' => 'es', 'es-PA' => 'es', 'es-PE' => 'es', 'es-PY' => 'es', 'es-SV' => 'es',
          'es-UY' => 'es', 'fr-BF' => 'fr', 'fr-CA' => 'fr', 'fr-CD' => 'fr', 'fr-CI' => 'fr', 'fr-GF' => 'fr',
          'fr-GP' => 'fr', 'fr-MC' => 'fr', 'fr-ML' => 'fr', 'fr-MU' => 'fr', 'fr-PF' => 'fr', 'it-VA' => 'it',
          'ms-SG' => 'ms', 'nl-BE' => 'nl', 'pt-AO' => 'pt', 'pt-BR' => 'pt', 'pt-MZ' => 'pt', 'ro-MD' => 'ro',
          'sr-ME' => 'sr', 'sq-XK' => 'sq', 'zh-HK' => 'zh', 'zh-SG' => 'zh', 'zh-TW' => 'zh'
        ).freeze
      end

      def self.default_iso_3166_1_mapping_lowercase
        @default_iso_3166_1_mapping_lowercase ||= TMDb::Web::Translations.default_iso_3166_1_mapping.each_with_object({}) do |(i18n, iso_3166_1), hash|
          hash[i18n.downcase] = i18n
        end.freeze
      end

      def self.valid_i18n_translations
        @valid_i18n_translations ||= TMDb::Web::Translations.language_list.dup.delete_if { |k,v| IGNORED_TRANSLATIONS.include?(k) }.freeze
      end

      def self.default_iso_3166_1_i18n
        @default_iso_3166_1_i18n ||= DEFAULT_COUNTRY_MAPPING
      end

      def self.default_language_i18n
        @default_language_i18n ||= LANGUAGE_CODES.each_with_object({}) { |iso_639_1, hash|
          hash[iso_639_1] = "#{iso_639_1}-#{iso_639_1.upcase}"
        }.merge(DEFAULT_MAPPING).freeze
      end

      def self.default_language_to_country_mapping
        @default_language_to_country_mapping ||= Hash[DEFAULT_MAPPING.map { |k,v| v.split('-') }].freeze
      end

      def self.language_list
        @language_list ||= (LANGUAGE_CODES - TMDb::Web::Translations.supported_iso_639_1).each_with_object({}) do |iso_639_1, hash|
          hash["#{iso_639_1}-#{iso_639_1.upcase}"] = "#{iso_639_1}"
        end.merge(TMDb::Web::Translations.default_iso_3166_1_mapping).sort_by { |h,v| v }.to_h.freeze
      end

      def self.language_path
        File.dirname(__FILE__) + "/../../../../languages"
      end

      # This list of ordinal localizations is sourced from the rails-i18n gem (v7.0.9)
      # To update values, clone the repo and copy the rails/ordinals directory.
      # https://github.com/svenfuchs/rails-i18n
      def self.ordinal_path
        File.dirname(__FILE__) + "/../../../../ordinals"
      end

      def self.load_path
        File.dirname(__FILE__) + "/../../../../locales"
      end

      def self.parse_valid_i18n(string)
        return ['en-US', 'en', 'US'] if (string.nil? || string == '')

        begin
          language, region = string.split('-')
          if (region = region&.upcase)
            ["#{language}-#{region}", language, region]
          else
            ["#{language}-#{language.upcase}", language, language.upcase]
          end
        rescue
          ['en-US', 'en', 'US']
        end
      end

      def self.supported_rtl?(language)
        RTL_LANGUAGE_CODES.include?(language)
      end

      def self.supported_iso_639_1
        DEFAULT_MAPPING.keys
      end

      def self.supported_iso_639_1_path
        @supported_iso_639_1_path ||= TMDb::Web::Translations.supported_iso_639_1.map { |iso| "/#{iso}" }.freeze
      end

      def self.transliteration_path
        File.dirname(__FILE__) + "/../../../../transliteration"
      end

    end
  end
end
