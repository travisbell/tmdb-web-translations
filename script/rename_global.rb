#!/usr/bin/env ruby

require "optparse"
require "set"
require "tempfile"
require "yaml"

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
      yaml = YAML.load_file(file_path)
      yaml[locale].each do |key, value|
        if value.is_a?(String)
          substitution = "global.#{key.parameterize(separator: "_")}"
          mapping << [key, substitution]
        end
      end
    end

    mapping_yaml = YAML.dump(mapping.sort.to_h)
    File.write(@mapping_output, mapping_yaml)
  else
    mapping = @mapping_input ? YAML.load_file(@mapping_input) : {}

    yaml_files(ARGV).each do |file_path|
      locale = File.basename(file_path, ".yml")
      update_yaml(file_path) do |yaml|
        translations = yaml[locale]
        translations["global"] ||= {}

        # NOTE: This only works for top-level keys.
        mapping.each do |old_key, new_key|
          value = translations.delete(old_key)
          _, new_key = new_key.split(".", 2)

          translations["global"][new_key] = value if value
        end

        yaml
      end
    end
  end
end

def yaml_files(args)
  args.flat_map { |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  }
end

def update_yaml(file_path, &block)
  yaml = YAML.load_file(file_path)
  yield yaml

  tempfile = Tempfile.create(File.basename(file_path))
  tempfile.write(YAML.dump(yaml, line_width: -1))

  File.unlink(file_path)
  File.link(tempfile.path, file_path)
end
