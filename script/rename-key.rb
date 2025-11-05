#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage:
# script/rename.rb [options] <reference> [target1 target2 ...]

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "tempfile"
require "yaml"

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
  yaml_files.each do |file_path|
    puts "Updating #{file_path}" if @verbose

    update_yaml(file_path) do |yaml|
      renamer.apply(yaml)
    end
  end
end

def yaml_files
  ARGV.flat_map { |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  }
end

def update_yaml(file_path, &block)
  yaml = YAML.load_file(file_path)
  updated_yaml = yield yaml

  tempfile = Tempfile.create(File.basename(file_path))
  tempfile.write(YAML.dump(updated_yaml, line_width: -1))

  File.unlink(file_path)
  File.link(tempfile.path, file_path)
end
