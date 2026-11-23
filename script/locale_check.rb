#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "tmdb/yaml_file"

# With no arguments, validate all translation data. Extra root keys, duplicate
# keys and implicitly typed ISO codes are failures rather than warnings.
paths = ARGV.empty? ? ["countries", "languages", "locales", "ordinals", "transliteration"] : ARGV
failures = []
TMDb::YamlFile.paths(paths).each do |path|
  # Weblate creates '{}' placeholders for newly added country and language locales.
  # They are valid only for these two components; website locale files need a root.
  yaml = TMDb::YamlFile.load(path)
  locale = File.basename(path, ".yml")
  component = File.basename(File.dirname(path))
  next if yaml.empty? && %w[countries languages].include?(component)

  unless yaml.keys == [locale]
    raise TMDb::YamlFile::InvalidYaml, "#{path}: expected only root #{locale.inspect}, got #{yaml.keys.inspect}"
  end
rescue TMDb::YamlFile::InvalidYaml, Errno::ENOENT => error
  failures << error.message
end
failures.each { |message| warn message }
exit(failures.empty? ? 0 : 1)
