#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "set"
require "yaml"
require "tmdb/yaml_file"
require "tmdb/i18n_rename"

require "active_support"
require "active_support/core_ext/string/inflections"

# Usage:
# script/rename.rb [options] <reference> [target1 target2 ...]
#
# Existing key is mapped to a new key. eg.
#
# __RENAME__:
#   awards:
#     add_category: awards.categories.add_category
#     add_ceremony: awards.ceremonies.add_ceremony

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [target_dirs ... target_files ...]"
  parser.on("-m", "--mapping FILE", "Rename using mapping file") do |path|
    @mapping_input = path
  end
  parser.on("-o", "--output FILE", "Output mapping file") do |path|
    @mapping_output = path
  end
end.parse!

at_exit do
  if @mapping_output
    mapping = Set.new

    yaml_files(ARGV).each do |file_path|
      locale = File.basename(file_path, ".yml")
      yaml = TMDb::YamlFile.load(file_path)
      yaml[locale].each do |key, value|
        if value.is_a?(String)
          substitution = "global.#{key.parameterize(separator: "_")}"
          mapping << [key, substitution]
        end
      end
    end

    collisions = mapping.group_by(&:last).select { |_destination, pairs| pairs.size > 1 }
    unless collisions.empty?
      abort collisions.map { |destination, pairs| "#{destination} <= #{pairs.map(&:first).inspect}" }.unshift("Colliding destinations:").join("\n  ")
    end

    mapping_yaml = YAML.dump(mapping.sort.to_h)
    TMDb::AtomicFile.write(@mapping_output, mapping_yaml)
  else
    mapping = @mapping_input ? TMDb::YamlFile.load(@mapping_input) : {}

    TMDb::YamlFile.update_all(yaml_files(ARGV)) do |_file_path, yaml|
      # NOTE: This only works for top-level keys.
      mapping.each do |old_key, new_key|
        group, key = new_key.split(".", 2)
        unless group == "global" && key && !key.empty?
          raise ArgumentError, "expected a destination under global for #{old_key.inspect}"
        end
        yaml = I18nRename.new(old_key: [old_key], new_key: ["global", key]).apply(yaml)
      end

      yaml
    end
  end
end

def yaml_files(args)
  args.flat_map do |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  end
end
