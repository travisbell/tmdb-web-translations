#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "optparse"
require "tmdb/yaml_file"
require "tmdb/pluralization_files"

root = File.expand_path("..", __dir__)
check = false
OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [--check]"
  parser.on("--check", "Check wrappers without writing") { check = true }
end.parse!

begin
  rules = TMDb::YamlFile.load(File.join(root, "config/pluralization.yml"))
  locales = Dir.glob(File.join(root, "locales/*.yml")).map { |path| File.basename(path, ".yml") }
  missing = locales - rules.keys
  abort "Missing Weblate pluralization mappings: #{missing.join(', ')}" unless missing.empty?
  rules.each_value do |rule|
    unless rule.is_a?(String) && rule.match?(/\A[a-z]+(?:_[a-z]+)*\z/) && File.exist?(File.join(root, "lib/weblate/pluralization/#{rule}.rb"))
      abort "Unknown Weblate pluralization rule: #{rule.inspect}"
    end
  end
  generator = TMDb::PluralizationFiles.new(rules)
  destination = File.join(root, "pluralization")
  if check
    changed, extras = generator.differences(destination)
    abort "Pluralization wrappers differ: #{(changed + extras).join(', ')}" unless changed.empty? && extras.empty?
  else
    generator.write(destination).each { |locale| puts "Updated pluralization/#{locale}.rb" }
  end
rescue TMDb::YamlFile::InvalidYaml, ArgumentError => error
  abort error.message
end
