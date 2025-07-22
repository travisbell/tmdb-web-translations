#!/usr/bin/env ruby

require "bundler/setup"
require_relative "../lib/tmdb/web/translations"

# This script generates pluralization files for each of our locales using files from the
# rails-i18n gem.

RAILS_I18N_PATH = Bundler.rubygems.find_name('rails-i18n').first.full_gem_path

LOCALES = Dir.glob("locales/*.yml").map { |path| File.basename(path, ".yml") }
PLURALIZERS = Dir.glob(File.join(RAILS_I18N_PATH, "/rails/pluralization/*.rb")).map { |path| [File.basename(path, ".rb"), path] }.to_h
ONE_OTHERS = ["af-ZA", "no-NO", "so-SO", "uz-UZ"]

LOCALES.each do |locale|
  iso_3166_1 = TMDb::Web::Translations.default_iso_3166_1_mapping.fetch(locale, locale)

  if PLURALIZERS.key?(locale)
    puts "#{PLURALIZERS[locale]} -> pluralization/#{locale}.rb"
    pluralizer = File.read(PLURALIZERS[locale])
  elsif PLURALIZERS.key?(iso_3166_1)
    puts "#{PLURALIZERS[iso_3166_1]} -> pluralization/#{locale}.rb"
    # Update locale used for pluralization rules and fix RailsI18n scoping.
    pluralizer = File.read(PLURALIZERS[iso_3166_1])
      .gsub(/:#{iso_3166_1} =>/, ":'#{locale}' =>")
      .gsub(/\.with_locale\(:#{iso_3166_1}\)/, ".with_locale(:'#{locale}')")
      .gsub(":rule => RailsI18n", ":rule => ::RailsI18n")
  elsif ONE_OTHERS.include?(locale)
    puts "RailsI18n::Pluralization::OneOther -> pluralization/#{locale}.rb"
    pluralizer = <<~RUBY
      require 'rails_i18n/common_pluralizations/one_other'

      ::RailsI18n::Pluralization::OneOther.with_locale(:'#{locale}')
    RUBY
  else
    puts "No pluralizer for #{locale}"
  end


  if pluralizer
    File.open("pluralization/#{locale}.rb", "w") do |file|
      file.puts(pluralizer)
    end
  end
end
