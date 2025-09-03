#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "yaml"
require "tempfile"
require "optparse"

require "tmdb/web/translations"
require "tmdb/i18n_patch"

# This synchronizes keys from a reference file to target files.
# Usage: ruby script/sync.rb [options] [target_file1 target_file2 ...]

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options]"
  parser.on("--no-sort-keys", "Dont't sort top level keys") do
    @no_sort_keys = false
  end
  parser.on("-v", "--verbose", "Verbose output") do
    @verbose = true
  end
end.parse!

at_exit do
  patch_yaml = YAML.load_file(ARGV.shift)
  patch_locale = patch_yaml.keys.first

  update_each_yaml(ARGV) do |file_path, yaml|
    puts "Patching #{file_path}" if @verbose

    locale = yaml.keys.first
    patch = I18nPatch.new(patch_yaml[patch_locale], locale:)

    patched_yaml = patch.apply(yaml[locale], empty: locale != patch_locale)
    patched_yaml = patched_yaml.sort.to_h unless @no_sort_keys

    yaml[locale] = patched_yaml
  end
end

def update_each_yaml(paths = ARGV, &block)
  yaml_files = paths.flat_map do |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  end

  yaml_files.each do |file_path|
    yaml = YAML.load_file(file_path)
    yield file_path, yaml

    tempfile = Tempfile.create(File.basename(file_path))
    tempfile.write(YAML.dump(yaml, line_width: -1))

    File.unlink(file_path)
    File.link(tempfile.path, file_path)
  end
end
