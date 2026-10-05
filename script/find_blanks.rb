#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "tmdb/yaml_file"
require "tmdb/i18n_missing_translations"

component = "locales"
directory = File.expand_path("..", __dir__)
OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] <locale> [locale ...]"
  parser.on("--component COMPONENT", ["locales", "countries", "languages"], "Translation component (default: locales)") { |value| component = value }
  parser.on("--directory DIRECTORY", "Repository directory") { |value| directory = value }
end.parse!
abort "Usage: #{$PROGRAM_NAME} [options] <locale> [locale ...]" if ARGV.empty?

# Plural categories used by a locale, from the reviewed rule map. Unknown
# locales keep every source category in the worklist.
def plural_keys(locale)
  rules_path = File.expand_path("../config/pluralization.yml", __dir__)
  rule = (@rules ||= TMDb::YamlFile.load(rules_path))[locale]
  return unless rule

  require "weblate/pluralization/#{rule}"
  name = rule.split("_").map(&:capitalize).join
  Weblate::Pluralization.const_get(name).with_locale(locale).dig(locale, :i18n, :plural, :keys).map(&:to_s)
end

begin
  source = TMDb::YamlFile.load(File.join(directory, component, "en-US.yml"), locale: "en-US")
  ARGV.each do |locale|
    target = TMDb::YamlFile.load(File.join(directory, component, "#{locale}.yml"), locale: locale)
    puts "# #{locale}" if ARGV.size > 1
    I18nMissingTranslations.find(source["en-US"], target[locale], plural_keys: plural_keys(locale)).each do |path, value|
      puts "BLANK: #{path.join('.')} => #{value.inspect}"
    end
  end
rescue TMDb::YamlFile::InvalidYaml, Errno::ENOENT => error
  abort error.message
end
