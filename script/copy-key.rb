#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage:
# script/copy.rb [options] <reference> [target1 target2 ...]

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "yaml"
require "tmdb/yaml_file"

require "tmdb/web/translations"
require "tmdb/i18n_rename"

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [target1 target2 ...]"
  parser.on("--old-key VALUE", "Old key") do |value|
    @old_key = value.split(".")
  end
  parser.on("--new-key VALUE", "New key") do |value|
    @new_key = value.split(".")
  end
  parser.on("-v", "--verbose", "Verbose output") do
    @verbose = true
  end
end.parse!

at_exit do
  renamer = I18nRename.new(old_key: @old_key, new_key: @new_key)
  written = TMDb::YamlFile.update_all(yaml_files) { |_file_path, yaml| renamer.apply(yaml, delete_old_key: false) }
  written.each { |file_path| puts "Updated #{file_path}" } if @verbose
end

def yaml_files
  ARGV.flat_map do |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  end
end
