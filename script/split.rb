#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "yaml"
require "tmdb/yaml_file"

# Usage:
# ruby script/sort.rb --sort-keys ~/Downloads/i18n_locales.yml

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options]"
  parser.on("-s", "--sort-keys") do
    @sort = true
  end
end.parse!

at_exit do
  source_path = ARGV.shift
  abort if source_path.nil? || source_path.empty?

  data = TMDb::YamlFile.load(source_path)
  data.each do |locale, translations|
    data = { locale => translations }
    data = deep_sort_keys(data) if @sort

    file_path = "locales/#{locale}.yml"

    TMDb::YamlFile.write(file_path, data)
  end
end

def deep_sort_keys(obj, new_obj = {})
  obj.each do |key, value|
    new_obj[key] = if value.is_a?(Hash)
      deep_sort_keys(value, {}).sort.to_h
    else
      value
    end
  end

  new_obj
end
