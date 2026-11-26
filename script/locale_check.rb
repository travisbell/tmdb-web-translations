#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "tmdb/yaml_file"

# With no arguments, validate all translation data. Extra root keys, duplicate
# keys and implicitly typed ISO codes are failures rather than warnings.
paths = ARGV.empty? ? ["countries", "languages", "locales", "ordinals", "transliteration"] : ARGV
failures = []
TMDb::YamlFile.paths(paths).each do |path|
  # Weblate may add empty country/language placeholders before translations arrive.
  component = File.basename(File.dirname(path))
  allow_empty = %w[countries languages].include?(component)
  TMDb::YamlFile.load(path, locale: File.basename(path, ".yml"), allow_empty: allow_empty)
rescue TMDb::YamlFile::InvalidYaml, Errno::ENOENT => error
  failures << error.message
end
failures.each { |message| warn message }
exit(failures.empty? ? 0 : 1)
